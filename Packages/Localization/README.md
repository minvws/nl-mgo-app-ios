# Localization

## Overview

This package provides an open-api generated client to download localization datasets from a remote server. It supports two datasets:

- **`organizations`** — the list of healthcare organizations.
- **`endpoints`** — the list of service endpoints.

Requests use ETags for conditional fetching, so data is only transferred when it has changed since the last download.

## Usage

### Fetching a dataset

```swift
import Localization

let client = LocalizationAPIClient(serverUrl)

let (statusCode, eTag, data) = try await client.fetch(.organizations, eTag: storedETag)
switch statusCode {
case 200:
    // New data received — persist `data` and update the stored eTag
case 304:
    // Data unchanged — use locally cached version
default:
    break
}
```

### With Basic Authentication

```swift
import Localization

let client = LocalizationAPIClient(serverUrl, username: username, password: password)
```

### Available endpoints

| Case | Description |
|------|-------------|
| `.organizations` | Healthcare organizations dataset |
| `.endpoints` | Service endpoints dataset |

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
