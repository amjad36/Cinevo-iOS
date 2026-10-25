//
//  NetworkClient.swift
//  Cinevo-iOS
//

import Foundation

/// Executes `Endpoint`s. Depend on this protocol rather than `URLSessionNetworkClient`
/// so a stub can be injected in tests.
protocol NetworkClient: Sendable {
    /// Sends the request and decodes a 2xx response body as `T`.
    func send<T: Decodable>(_ endpoint: any Endpoint, as type: T.Type) async throws -> T

    /// Sends the request and ignores the response body (e.g. 204 No Content).
    func send(_ endpoint: any Endpoint) async throws
}
