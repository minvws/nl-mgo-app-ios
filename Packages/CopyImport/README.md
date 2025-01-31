# Copy Import

## Overview

This package will transform a strings file into a xcstrings file

## Usage

Point the `--source-path` to the [strings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html) file, and the `--target-path` to the desired [xcstrings](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog) file

```swift

	swift run CopyImport --source-path ../../tmp/localization_downloads/nl.lproj/Localizable.strings --target-path ../../tmp/localization_downloads/Localizable.xcstrings
	
	rm -f ./Sources/MGO/Resources/Localizable.xcstrings
	cp ./tmp/localization_downloads/Localizable.xcstrings ./Sources/MGO/Resources/Localizable.xcstrings

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/CopyImport/LICENSE.txt) for details.
