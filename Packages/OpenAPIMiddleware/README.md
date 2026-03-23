# OpenAPIMiddleware

## Overview

This package provides middleware helpers for API clients generated with the [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator).

- **`AuthorizationMiddleware`** — attaches a Basic Auth or Bearer token `Authorization` header to every outgoing request.
- **`StripHeaderEncodingMiddleware`** — removes percent-encoding from specified request headers before they are sent.

## Usage

### AuthorizationMiddleware

#### Basic Authentication

```swift
import OpenAPIMiddleware
import OpenAPIRuntime
import OpenAPIURLSession

let authMiddleware = AuthorizationMiddleware(username: username, password: password)
let client = Client(
    serverURL: serverUrl,
    transport: URLSessionTransport(),
    middlewares: [authMiddleware]
)
```

#### Bearer Token

```swift
import OpenAPIMiddleware
import OpenAPIRuntime
import OpenAPIURLSession

let authMiddleware = AuthorizationMiddleware(token: token)
let client = Client(
    serverURL: serverUrl,
    transport: URLSessionTransport(),
    middlewares: [authMiddleware]
)
```

### StripHeaderEncodingMiddleware

Some servers do not accept percent-encoded header values. Use this middleware to strip the encoding from specific headers before the request is sent.

```swift
import OpenAPIMiddleware
import OpenAPIRuntime
import OpenAPIURLSession

let stripMiddleware = StripHeaderEncodingMiddleware(strippableHeaders: [.contentType])
let client = Client(
    serverURL: serverUrl,
    transport: URLSessionTransport(),
    middlewares: [stripMiddleware]
)
```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
