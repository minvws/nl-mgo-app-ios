# MGO Repository

## Overview

The repositories for the BGZ Concern, LaboratoryTestResult and MedicationUse. Each of the repositories uses the FHIR Client and the FHIR Extensions to map the servers FHIR response on to readable classes. 

## Usage

To fetch a list of concerns ([Condition](https://github.com/apple/FHIRModels/blob/main/Sources/ModelsSTU3/Condition.swift)) from the server:

```swift

import MGORepository

let concernRepository: ConcernRepository? = FHIRClient()

do {
	let concerns: [MgoConcern] = try await concernRepository.fetchConcerns()
	....
} catch {
	logError("Client read error: \(String(describing: error))")
}
```

To fetch a list of laboratoryTestResuls ([Observation](https://github.com/apple/FHIRModels/blob/main/Sources/ModelsSTU3/Observation.swift)) from the server:

```swift
let resultRepository: LaboratoryTestResultRepository? = FHIRClient()

do {
	let results: [MgoLaboratoryTestResult] = try await resultRepository.fetchResults()
	....
} catch {
	logError("Client read error: \(String(describing: error))")
}
```

To fetch a list of medicationUse ([MedicationStatement](https://github.com/apple/FHIRModels/blob/main/Sources/ModelsSTU3/MedicationStatement.swift)) from the server:

```swift
let medicationRepository: MedicationUseRepository? = FHIRClient()

do {
	let tuples: [(Zib, UISchema)] = try await medicationRepository.fetchMedicationUse()
	....
} catch {
	logError("Client read error: \(String(describing: error))")
}

```

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/LICENSE.txt) for details.
