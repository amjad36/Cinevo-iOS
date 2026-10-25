# Task: Build a Reusable Network Layer in My iOS Movie DB Project

# Role

Act as a Senior iOS Engineer who specializes in modern Swift concurrency, SOLID principles, dependency injection, and testable iOS code.

# Objective

I want to implement a reusable, maintainable, production-oriented networking layer in my existing iOS app using:

- Swift
- Swift Concurrency (`async/await`)
- URLSession
- Codable
- Protocol-based dependency injection
- XCTest

The layer must be generic and API-agnostic so that any future feature (TMDB or any other backend) can reuse it without modifying it.

Scope of this task is **only the networking layer**. Do not create any concrete API endpoints, do not call any real API, and do not build repositories, ViewModels, or screens yet.

# 1. Inspect the Existing Project First

Before changing files:

1. Inspect the project structure and existing source files.
2. Identify the Swift version, iOS deployment target, and Xcode version.
3. Respect the Xcode 14 project-format constraints described in `CLAUDE.md` (explicit `PBXFileReference` / `PBXBuildFile` entries, `objectVersion = 56`, iOS 16.0 deployment target, XCTest only).
4. Identify any existing networking code that should be preserved.

If important details are missing, ask concise clarification questions.

# 2. Components

Place all files in a `Networking` group inside the app target.

Suggested components:
- `HTTPMethod`
- `Endpoint` protocol — describes a request (base URL, path, method, headers, query items, optional body) with sensible defaults
- `HTTPBody` — JSON-encodable body or raw data with a content type
- `NetworkClient` protocol
- `URLSessionNetworkClient` — the concrete implementation
- `NetworkError`

Avoid excessive abstraction, redundant wrappers, and protocols that have no clear purpose.

# 3. Requirements

- Use URLSession and async/await.
- Support generic `Decodable` response types.
- Support GET, POST, PUT, PATCH, and DELETE.
- Support query parameters, headers, and optional HTTP bodies (`Encodable` JSON or raw `Data`).
- Use URLComponents for safe URL construction.
- Validate HTTP status codes.
- Make `URLSession`, `JSONDecoder`, and `JSONEncoder` injectable.
- Support client-wide default headers; endpoint headers override them.
- Authentication is supplied by the caller as headers (e.g. `Authorization: Bearer …`); the client must not hardcode any auth scheme or credential.
- Propagate cancellation.
- Do not automatically retry requests.
- Do not put any API-specific (TMDB or otherwise) logic in the networking layer.

# 4. Error Handling

Design a `NetworkError` that covers:

- Invalid URL
- Request body encoding failure
- Non-HTTP / invalid response
- 401 Unauthorized
- 429 Too Many Requests (expose `Retry-After` when present)
- Other 4xx client errors (including 403 and 404)
- 5xx server errors
- JSON decoding failure

Rules:
- Transport failures (offline, timeout, …) are not wrapped; they propagate as `URLError`.
- Cancellation must not be reported as a network failure. Rethrow `CancellationError` so callers can distinguish it from real errors.
- Preserve the status code and response body on HTTP errors so higher layers can inspect them.
- Do not silently swallow errors.

# 5. Unit Testing

Add XCTest coverage using a `URLProtocol` stub injected through a custom `URLSession`. Tests must not require internet access or credentials.

Cover:
- URL, path, and query-item construction (including characters that need encoding)
- Header merging (default vs endpoint headers)
- JSON request body and `Content-Type`
- Successful decoding
- Every HTTP error mapping listed above
- Invalid JSON
- Transport failures
- Cancellation

# 6. Code Quality

- Follow modern Swift naming conventions.
- Use access control appropriately.
- Respect Swift concurrency safety; mark types `Sendable` where appropriate.
- Avoid force unwraps and hidden failures.
- Avoid massive files and unnecessary abstractions.
- Do not introduce a third-party networking library.
- Make the implementation compatible with the project's actual Swift version and deployment target.
- Do not claim code compiles unless verified.

# 7. Out of Scope (Future Specs)

The following will be covered by later specs that build on this layer. Do not implement them now:

- TMDB endpoints, configuration, and access token
- DTOs and mappers
- Domain entities, repositories, and use cases
- ViewModels and SwiftUI screens
- Composition root / dependency container

# 8. Implementation Workflow

1. Inspect the project.
2. Implement the networking components and register them in `project.pbxproj`.
3. Add unit tests and register them in the test target.
4. Build and run the tests.

When done:
- List the files created or modified and the purpose of each.
- Explain how a future feature would define an endpoint and use the client.
- Identify any assumptions.
- Report the actual build and test results.

# 9. Teaching Requirements

Explain the design as if mentoring an iOS developer preparing for senior-level interviews:

- Why `NetworkClient` is a protocol and how it enables dependency injection and testing
- Why `Endpoint` is a protocol rather than a concrete type
- How errors are mapped and why cancellation is kept separate
- How async/await cancellation propagates through URLSession
- Why this is better than calling URLSession directly from feature code
