//
//  NetworkError.swift
//  Cinevo-iOS
//

import Foundation

/// Failures raised by `NetworkClient`.
///
/// Cancellation is deliberately not a case: a cancelled request throws `CancellationError`,
/// so callers can ignore it instead of presenting it as a failure.
enum NetworkError: Error {
    case invalidURL
    case encodingFailed(Error)
    case transport(URLError)
    /// The response was not an `HTTPURLResponse`, or had an unexpected (1xx/3xx) status code.
    case invalidResponse
    case unauthorized(data: Data)
    case forbidden(data: Data)
    case notFound(data: Data)
    /// `retryAfter` is the `Retry-After` header in seconds, when the server sent one.
    case rateLimited(retryAfter: TimeInterval?, data: Data)
    case clientError(statusCode: Int, data: Data)
    case serverError(statusCode: Int, data: Data)
    case decodingFailed(Error)
}
