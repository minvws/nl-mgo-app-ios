# MGO Repository

## Overview

The MGO Repository is used to fetch the various Zibs from a DVA.  

## Usage

To fetch a list of ([Medication Use](https://zibs.nl/wiki/MedicationUse2-v1.1.1(2020EN))) from the server:

```swift

import MGORepository

// The FHIR Client (for the dva proxy)
let url = URL(string: "https://dvp-proxy.mgo.irealisatie.nl/fhir")
let client = FHIRClient(baseURL: url)

// The repository
let repository = MGORepository(client: client)

// Array to hold the resources
var mgoResources = [MgoResource]()

// Resource endpoint
let endpoint = DVP.Endpoint(
	path: "MedicationStatement",
	parameters: RequestParameters(
		[
			(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
			(RequestParameterField.include, "MedicationStatement:medication")
		]
	),
	serviceId: "48" // BGZ has serviceId 48
)

// The DVA to fetch the data from
let dva = "https://dva-mock.mgo.irealisatie.nl/48"

do {
	// A FHIR Bundle 
	let fhirBundle = try await repository.getBundleData(
		endpoint: endpoint,
		dvaTarget: dvaTarget,
		username: "Basic Auth username",
		password: "Basic Auth password"
	)
	// The Zibs
	mgoResources = try repository.process(fhirBundle, fhirVersion: "R3")
	...
	
} catch {
	logError("error fetching resources", error)
}

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/MGORepository/LICENSE.txt) for details.
