# Local Authentication Provider

## Overview

Use this package for local authentication i.e. face id, touch id etc. 

## Usage

```swift

import LocalAuthenticationProvider

let localAuthenticationProvider = LocalAuthenticationProvider()

do {
	let authenticated = try await localAuthenticationProvider.authenticate(
		localizedReason: "info text for touch id",
		localizedFallbackTitle: "text for fallback option"
	)
	if authenticated {
		// Success
		...
	}
} catch LocalAuthenticationError.canceled {
	// Cancelled, stay on the scene
	logWarning("User cancelled the biometric request.")
	...
} catch LocalAuthenticationError.authenticationFailed {
	// The authentication failed, wrong id
	logWarning("Authentication Failed")
	...
} catch LocalAuthenticationError.userFallback {
	// User opted for the fallback option
	logWarning("User selected password option")
	...
} catch LocalAuthenticationError.declined {
	// User denied access
	logWarning("User declined biometric access")
	...
} catch LocalAuthenticationError.lockout {
	// Too many attempts, locked out. 
	logWarning("BioMetric setup lockout")
	...
} catch {
	// Other error
	logError("error: \(error)")
	...
}

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/LocalAuthenticationProvider/LICENSE.txt) for details.
