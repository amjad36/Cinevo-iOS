//
//  Endpoint.swift
//  Cinevo-iOS
//

import Foundation

/// Describes a single HTTP request. Features declare their own conforming types
/// (typically an enum per API) and hand them to a `NetworkClient`.
protocol Endpoint: Sendable {
    var baseURL: URL { get }
    /// Appended to `baseURL`'s path; a leading "/" is optional.
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: HTTPBody? { get }
}

extension Endpoint {
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: HTTPBody? { nil }

    func makeURLRequest(encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        var basePath = components.path
        if basePath.hasSuffix("/") {
            basePath.removeLast()
        }
        components.path = basePath + (path.hasPrefix("/") ? path : "/" + path)

        if !queryItems.isEmpty {
            components.queryItems = queryItems
            // URLComponents leaves "+" unescaped, but most servers decode it as a space.
            components.percentEncodedQuery = components.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        if let body {
            let contentType: String
            switch body {
            case .json(let value):
                do {
                    request.httpBody = try encoder.encode(value)
                } catch {
                    throw NetworkError.encodingFailed(error)
                }
                contentType = "application/json"
            case .data(let data, let type):
                request.httpBody = data
                contentType = type
            }
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
