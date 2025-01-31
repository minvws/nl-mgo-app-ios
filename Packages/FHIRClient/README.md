# FHIR Client

## Overview

This package will handle all the FHIR calls to the server. 

## Usage

```swift

import FHIRClient

let url = URL(string: "https://hapi.fhir.org/baseDstu3")
let client = FHIRClient(baseURL: url)

// BGZ Parameters for MedicationStatement
// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/FHIR_BGZ_2017
let parameters = RequestParameters(
	[
		(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
		(RequestParameterField.include, "MedicationStatement:medication")
	]
)

do {
		let data = try await client.readDataFrom(
			"/MedicationStatement",
			parameters: parameters,
			headers: RequestHeaders([RequestHeaderField.accept: "application/fhir+json"])
		)
	...
	
} catch {
	logError("Client error: \(String(describing: error))")
}

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/FHIRClient/LICENSE.txt) for details.
