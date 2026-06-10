# Copy Import

## Overview

This package transforms Lokalise-exported translation files into a single [xcstrings](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog) catalog:

- A [`.strings`](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html) file containing flat key/value pairs → xcstrings `stringUnit` entries
- An optional `.stringsdict` plist file containing plural variants → xcstrings `variations.plural` entries

Both are merged into one output `.xcstrings` file.

## Usage

| Argument | Required | Description |
|---|---|---|
| `--source-path` | yes | Path to the `.strings` file |
| `--stringsdict-path` | no | Path to the `.stringsdict` plist file |
| `--target-path` | yes | Path for the generated `.xcstrings` file |

```bash
swift run CopyImport \
  --source-path ../../tmp/localization_downloads/nl.lproj/Localizable.strings \
  --stringsdict-path ../../tmp/localization_downloads/nl.lproj/Localizable.stringsdict \
  --target-path ../../tmp/localization_downloads/Localizable.xcstrings

rm -f ./Sources/MGO/Resources/Localizable.xcstrings
cp ./tmp/localization_downloads/Localizable.xcstrings ./Sources/MGO/Resources/Localizable.xcstrings
```

In practice this is handled automatically by `make download_translations`.

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
