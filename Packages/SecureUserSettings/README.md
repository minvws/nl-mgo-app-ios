# Secure User Settings

## Overview

Use this packaga to safely and securely store user settings

## Usage

You can safely store settings in the secure user settings:

```swift
	SecureUserSettings().userHasRemoteAuthentication = true
```

The values we are storing:

```swift

	/// Timestamp the app went to the background
	var enteredBackground: Date? // Defaults to nil
	
	/// the first entry of the access code
	var tempPinCode: String? // Defaults to nil
	
	/// the access code
	var pinCode: String? // Defaults to nil
	
	/// Do we have setup the biometric authentication
	var bioMetricAuthenticationEnabled: Bool // Defaults to false
	
	/// Have we seen the jail break warning?
	var userHasSeenJailBreakWarning: Bool // Defaults to false
	
	/// Did the user complete the DigiD flow?
	var userHasRemoteAuthentication: Bool // Defaults to false

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/SecureUserSettings/LICENSE.txt) for details.
