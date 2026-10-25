//
//  URLSessionNetworkClientTests.swift
//  Cinevo-iOSTests
//

import XCTest
@testable import Cinevo_iOS

private struct Item: Decodable, Equatable {
    let id: Int
    let title: String
}

final class URLSessionNetworkClientTests: XCTestCase {

    private static let itemJSON = Data(#"{"id": 1, "title": "Interstellar"}"#.utf8)

    private var sut: URLSessionNetworkClient!

    override func setUp() {
        super.setUp()
        URLProtocolStub.reset()
        sut = URLSessionNetworkClient(session: URLProtocolStub.makeSession())
    }

    override func tearDown() {
        URLProtocolStub.reset()
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func testDecodesSuccessfulResponse() async throws {
        URLProtocolStub.handler = { _ in .http(statusCode: 200, data: Data(#"{"id": 1, "title": "Interstellar"}"#.utf8)) }

        let item = try await sut.send(TestEndpoint(), as: Item.self)

        XCTAssertEqual(item, Item(id: 1, title: "Interstellar"))
    }

    func testSendsRequestBuiltFromEndpoint() async throws {
        URLProtocolStub.handler = { _ in .http(statusCode: 200, data: Self.itemJSON) }
        let endpoint = TestEndpoint(
            method: .post,
            queryItems: [URLQueryItem(name: "page", value: "1")],
            body: .data(Data("payload".utf8), contentType: "text/plain")
        )

        _ = try await sut.send(endpoint, as: Item.self)

        let request = try XCTUnwrap(URLProtocolStub.receivedRequests.first)
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/items?page=1")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.bodyData(), Data("payload".utf8))
    }

    func testDefaultHeadersAreSentAndEndpointHeadersWin() async throws {
        URLProtocolStub.handler = { _ in .http(statusCode: 200, data: Self.itemJSON) }
        sut = URLSessionNetworkClient(
            session: URLProtocolStub.makeSession(),
            defaultHeaders: ["Authorization": "Bearer default", "Accept": "application/json"]
        )

        _ = try await sut.send(TestEndpoint(headers: ["Authorization": "Bearer override"]), as: Item.self)

        let request = try XCTUnwrap(URLProtocolStub.receivedRequests.first)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer override")
    }

    // MARK: - HTTP errors

    func testStatus401ThrowsUnauthorized() async {
        await assertError(forStatus: 401) { error in
            guard case .unauthorized = error else { return false }
            return true
        }
    }

    func testStatus404ThrowsClientErrorWithBody() async {
        await assertError(forStatus: 404, data: Data("missing".utf8)) { error in
            guard case .clientError(let statusCode, let data) = error else { return false }
            return statusCode == 404 && data == Data("missing".utf8)
        }
    }

    func testStatus429ThrowsRateLimitedWithRetryAfter() async {
        await assertError(forStatus: 429, headers: ["Retry-After": "30"]) { error in
            guard case .rateLimited(let retryAfter, _) = error else { return false }
            return retryAfter == 30
        }
    }

    func testStatus429WithoutRetryAfterHasNilDelay() async {
        await assertError(forStatus: 429) { error in
            guard case .rateLimited(let retryAfter, _) = error else { return false }
            return retryAfter == nil
        }
    }

    func testOther4xxThrowsClientError() async {
        await assertError(forStatus: 400) { error in
            guard case .clientError(let statusCode, _) = error else { return false }
            return statusCode == 400
        }
    }

    func testStatus5xxThrowsServerError() async {
        await assertError(forStatus: 503) { error in
            guard case .serverError(let statusCode, _) = error else { return false }
            return statusCode == 503
        }
    }

    // MARK: - Decoding, transport, cancellation

    func testInvalidJSONThrowsDecodingFailed() async {
        URLProtocolStub.handler = { _ in .http(statusCode: 200, data: Data("not json".utf8)) }

        do {
            _ = try await sut.send(TestEndpoint(), as: Item.self)
            XCTFail("Expected an error")
        } catch NetworkError.decodingFailed {
            // Expected.
        } catch {
            XCTFail("Expected decodingFailed, got \(error)")
        }
    }

    func testTransportFailureThrowsURLError() async {
        URLProtocolStub.handler = { _ in .failure(URLError(.notConnectedToInternet)) }

        do {
            _ = try await sut.send(TestEndpoint(), as: Item.self)
            XCTFail("Expected an error")
        } catch let urlError as URLError {
            XCTAssertEqual(urlError.code, .notConnectedToInternet)
        } catch {
            XCTFail("Expected URLError, got \(error)")
        }
    }

    func testCancellingInFlightRequestThrowsCancellationError() async throws {
        let requestStarted = expectation(description: "Request reached the stub")
        URLProtocolStub.handler = { _ in
            requestStarted.fulfill()
            return .hang
        }
        let sut = self.sut!

        let task = Task { try await sut.send(TestEndpoint(), as: Item.self) }
        await fulfillment(of: [requestStarted], timeout: 2)
        task.cancel()

        do {
            _ = try await task.value
            XCTFail("Expected cancellation")
        } catch is CancellationError {
            // Expected.
        } catch {
            XCTFail("Expected CancellationError, got \(error)")
        }
    }

    func testCancelledTaskThrowsCancellationErrorBeforeRequest() async {
        URLProtocolStub.handler = { _ in .http(statusCode: 200, data: Data(#"{"id": 1, "title": "x"}"#.utf8)) }
        let sut = self.sut!

        let task = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            return try await sut.send(TestEndpoint(), as: Item.self)
        }

        do {
            _ = try await task.value
            XCTFail("Expected cancellation")
        } catch is CancellationError {
            // Expected.
        } catch {
            XCTFail("Expected CancellationError, got \(error)")
        }
    }

    // MARK: - Helpers

    private func assertError(
        forStatus statusCode: Int,
        headers: [String: String] = [:],
        data: Data = Data(),
        file: StaticString = #filePath,
        line: UInt = #line,
        matches: (NetworkError) -> Bool
    ) async {
        URLProtocolStub.handler = { _ in .http(statusCode: statusCode, headers: headers, data: data) }

        do {
            _ = try await sut.send(TestEndpoint(), as: Item.self)
            XCTFail("Expected an error for status \(statusCode)", file: file, line: line)
        } catch let error as NetworkError {
            XCTAssertTrue(matches(error), "Unexpected error \(error) for status \(statusCode)", file: file, line: line)
        } catch {
            XCTFail("Expected NetworkError, got \(error)", file: file, line: line)
        }
    }
}
