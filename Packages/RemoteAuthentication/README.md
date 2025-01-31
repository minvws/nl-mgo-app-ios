# Remote Authentication

## Overview

With the use of the [open-api generator](https://github.com/apple/swift-openapi-generator) this package creates methods to fetch the DigiD login url 

## Usage

You can fetch the authorization url from the proxy to open a link to the DigiD login page

```swift
import Remote Authentication

let remoteAuthenticationClient = RemoteAuthenticationClient(
	serverUrl: URL(string: "https://example.com")!,
	username: nil, // Basic Auth
	password: nil // Basic Auth
)

// The url to open when the DigiD flow is finished:
let callback = "mgo://app/login"

do {
	let authUrl = try await remoteAuthenticationClient.getAuthenticationUrl(callbackUrl: callback) 
	UIApplication.shared.open(authUrl)
} catch {
	logError("Error fetching DigiD login \(error)")
}

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

--- 

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/RemoteAuthentication/LICENSE.txt) for details.
