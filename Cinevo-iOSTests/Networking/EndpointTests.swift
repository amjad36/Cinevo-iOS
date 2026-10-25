//
//  EndpointTests.swift
//  Cinevo-iOSTests
//

import XCTest
@testable import Cinevo_iOS

struct TestEndpoint: Endpoint {
    var baseURL = URL(string: "https://api.example.com")!
    var path = "/items"
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem] = []
    var body: HTTPBody?
}

/// Uses only the protocol's default implementations.
private struct MinimalEndpoint: Endpoint {
    let baseURL = URL(string: "https://api.example.com/v1/")!
    let path = "status"
}

private struct Payload: Codable, Equatable {
    let name: String
    let count: Int
}

private struct Unencodable: Encodable {
    func encode(to encoder: Encoder) throws {
        throw EncodingError.invalidValue(self, .init(codingPath: [], debugDescription: "test"))
    }
}

final class EndpointTests: XCTestCase {

    func testDefaultsProduceGETWithoutBody() throws {
        let request = try MinimalEndpoint().makeURLRequest()

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
        XCTAssertNil(request.value(forHTTPHeaderField: "Content-Type"))
    }

    func testPathIsJoinedToBasePathWithSingleSlash() throws {
        let request = try MinimalEndpoint().makeURLRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/v1/status")
    }

    func testPathWithoutLeadingSlashIsJoined() throws {
        let endpoint = TestEndpoint(path: "items/42")

        let request = try endpoint.makeURLRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/items/42")
    }

    func testQueryItemsArePercentEncoded() throws {
        let endpoint = TestEndpoint(queryItems: [
            URLQueryItem(name: "query", value: "a+b c&d=é"),
            URLQueryItem(name: "page", value: "2"),
        ])

        let request = try endpoint.makeURLRequest()

        XCTAssertEqual(
            request.url?.absoluteString,
            "https://api.example.com/items?query=a%2Bb%20c%26d%3D%C3%A9&page=2"
        )
    }

    func testMethodAndHeadersAreApplied() throws {
        for method in [HTTPMethod.get, .post, .put, .patch, .delete] {
            let endpoint = TestEndpoint(method: method, headers: ["Authorization": "Bearer token"])

            let request = try endpoint.makeURLRequest()

            XCTAssertEqual(request.httpMethod, method.rawValue)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token")
        }
    }

    func testJSONBodyIsEncodedWithContentType() throws {
        let payload = Payload(name: "Interstellar", count: 3)
        let endpoint = TestEndpoint(method: .post, body: .json(payload))

        let request = try endpoint.makeURLRequest()

        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        let body = try XCTUnwrap(request.httpBody)
        XCTAssertEqual(try JSONDecoder().decode(Payload.self, from: body), payload)
    }

    func testRawDataBodyUsesGivenContentType() throws {
        let data = Data("hello".utf8)
        let endpoint = TestEndpoint(method: .put, body: .data(data, contentType: "text/plain"))

        let request = try endpoint.makeURLRequest()

        XCTAssertEqual(request.httpBody, data)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "text/plain")
    }

    func testExplicitContentTypeHeaderIsNotOverridden() throws {
        let endpoint = TestEndpoint(
            method: .post,
            headers: ["Content-Type": "application/vnd.api+json"],
            body: .json(Payload(name: "x", count: 1))
        )

        let request = try endpoint.makeURLRequest()

        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/vnd.api+json")
    }

    func testEncodingFailureThrowsEncodingFailed() {
        let endpoint = TestEndpoint(method: .post, body: .json(Unencodable()))

        XCTAssertThrowsError(try endpoint.makeURLRequest()) { error in
            guard case NetworkError.encodingFailed = error else {
                return XCTFail("Expected encodingFailed, got \(error)")
            }
        }
    }

    func testUnrepresentableURLThrowsInvalidURL() throws {
        // A host-less URL whose path starts with "//" cannot be represented by URLComponents.
        let endpoint = TestEndpoint(baseURL: try XCTUnwrap(URL(string: "local:")), path: "//items")

        XCTAssertThrowsError(try endpoint.makeURLRequest()) { error in
            guard case NetworkError.invalidURL = error else {
                return XCTFail("Expected invalidURL, got \(error)")
            }
        }
    }
}
