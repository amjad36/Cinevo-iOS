//
//  URLSessionNetworkClient.swift
//  Cinevo-iOS
//

import Foundation

/// `NetworkClient` backed by `URLSession`. It knows nothing about any specific API:
/// authentication and other API-wide headers are passed in through `defaultHeaders`.
/// Requests are never retried automatically.
///
/// `@unchecked Sendable`: all stored properties are immutable after `init`, and
/// `JSONEncoder`/`JSONDecoder` are safe to use concurrently once configured.
final class URLSessionNetworkClient: NetworkClient, @unchecked Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let defaultHeaders: [String: String]

    /// - Parameter defaultHeaders: Added to every request unless the endpoint sets the same field.
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        defaultHeaders: [String: String] = [:]
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.defaultHeaders = defaultHeaders
    }

    func send<T: Decodable>(_ endpoint: any Endpoint, as type: T.Type) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func perform(_ endpoint: any Endpoint) async throws -> Data {
        var request = try endpoint.makeURLRequest(encoder: encoder)
        for (field, value) in defaultHeaders where request.value(forHTTPHeaderField: field) == nil {
            request.setValue(value, forHTTPHeaderField: field)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        }
        // The task may have been cancelled after the response arrived.
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        try validate(httpResponse, data: data)
        return data
    }

    private func validate(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.unauthorized(data: data)
        case 429:
            // Only the delay-seconds form of Retry-After is parsed; an HTTP-date yields nil.
            let retryAfter = response.value(forHTTPHeaderField: "Retry-After").flatMap(TimeInterval.init)
            throw NetworkError.rateLimited(retryAfter: retryAfter, data: data)
        case 400..<500:
            throw NetworkError.clientError(statusCode: response.statusCode, data: data)
        case 500..<600:
            throw NetworkError.serverError(statusCode: response.statusCode, data: data)
        default:
            throw NetworkError.invalidResponse
        }
    }
}
