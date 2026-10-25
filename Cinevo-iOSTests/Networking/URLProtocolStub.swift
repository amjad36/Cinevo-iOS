//
//  URLProtocolStub.swift
//  Cinevo-iOSTests
//

import Foundation

/// Intercepts every request made through `URLProtocolStub.makeSession()` and answers it
/// from `handler`, so tests never touch the network.
final class URLProtocolStub: URLProtocol {
    enum Response {
        case http(statusCode: Int, headers: [String: String] = [:], data: Data = Data())
        case failure(Error)
        /// Never answers; used to test cancellation of an in-flight request.
        case hang
    }

    /// Shared between the test (writer) and URLSession's loading thread (reader).
    private final class State: @unchecked Sendable {
        let lock = NSLock()
        var handler: ((URLRequest) -> Response)?
        var receivedRequests: [URLRequest] = []
    }

    private static let state = State()

    static var handler: ((URLRequest) -> Response)? {
        get { state.lock.withLock { state.handler } }
        set { state.lock.withLock { state.handler = newValue } }
    }

    static var receivedRequests: [URLRequest] {
        state.lock.withLock { state.receivedRequests }
    }

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    static func reset() {
        state.lock.withLock {
            state.handler = nil
            state.receivedRequests = []
        }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let handler = Self.state.lock.withLock {
            Self.state.receivedRequests.append(request)
            return Self.state.handler
        }
        guard let handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            return
        }

        switch handler(request) {
        case .http(let statusCode, let headers, let data):
            guard let url = request.url,
                  let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers) else {
                client?.urlProtocol(self, didFailWithError: URLError(.badURL))
                return
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        case .hang:
            break
        }
    }

    override func stopLoading() {}
}

extension URLRequest {
    /// URLSession moves `httpBody` into `httpBodyStream` before a URLProtocol sees it.
    func bodyData() -> Data? {
        if let httpBody {
            return httpBody
        }
        guard let stream = httpBodyStream else {
            return nil
        }
        stream.open()
        defer { stream.close() }

        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 1024)
        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: buffer.count)
            guard count > 0 else { break }
            data.append(buffer, count: count)
        }
        return data
    }
}
