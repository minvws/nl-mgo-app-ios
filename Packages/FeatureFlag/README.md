# FeatureFlag

## Overview

Some of the features in the app are not finalized and/or may only be turned on in specific sitation. Currently there are two such features:
- isAutomaticLocalizationEnabled, used to prefetch the healthcare providers that have data for you
- isDemo, used to demonstrate the optimized flow

## Usage

```swift
import FeatureFlag
let featureFlagManager = FeatureFlagManager()

if featureFlagManager.isAutomaticLocalizationEnabled {
	// Navigate to automatic localization
	...
} else {
	/// Naviate to manual localization
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

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/FeatureFlag/LICENSE.txt) for details.
