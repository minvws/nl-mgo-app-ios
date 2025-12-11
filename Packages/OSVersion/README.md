# OSVersion

## Overview

This package provides a testable OS Version Checker 

## Usage

How to check?

```swift

func someMethod(versionChecker: OSVersionProtocol) {

	if osVersionChecker.available(version: .iOS(.v26)) {
		...
	}
}

let osVersionChecker = OSVersionChecker()

someMethod(versionChecker: osVersionChecker)

```

How to test?

```swift

func test_someMethod() {
	
	// Given
	let osVersionChecker: OSVersionProtocol = OSVersionCheckerTrue() // OSVersionCheckerFalse()

	// When
	someMethod(versionChecker: osVersionChecker)
	
	// Then
	#expect(....)
}
```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
