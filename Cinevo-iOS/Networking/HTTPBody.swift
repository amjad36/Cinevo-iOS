//
//  HTTPBody.swift
//  Cinevo-iOS
//

import Foundation

/// The payload of a request.
enum HTTPBody: Sendable {
    /// Encoded with the client's `JSONEncoder` and sent as `application/json`.
    case json(any Encodable & Sendable)
    /// Sent as-is with the given `Content-Type`.
    case data(Data, contentType: String)
}
