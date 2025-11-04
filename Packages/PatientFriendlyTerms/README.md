# Patient Friendly Terms

## Overview

This package is an open-api generated class to help download the latest Patient Friendly Terms

## Usage

Create a Patient Friendly Terms Repository with the server URL:

```swift

let serverUrl = URL(string: "example.com")
let repository = PatientFriendlyTermsRepository(
	client: PatientFriendlyTermsAPIClient(serverUrl)
)
```

To load the terms from the server:
```swift
await repository.fetchTerms()
```

To check if a term exists:
```swift

let displayValue: DisplayValue = ....

guard displayValue.system == PatientFriendlyTermsRepository.snomedCTSystem,
	let code = displayValue.code else {
	return nil
}
return repository.find(code) 

```

How to use a term?

```swift
let term = PatientFriendlyTerm(
	name: "name",
	description: "description",
	synonym: "synonym"
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
