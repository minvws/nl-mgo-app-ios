# Parsing Core

## Overview

A shared Javascript FHIR -> Zib parser.

This parser is written in Javascript (Typescript) and is used for the web, iOS and Android application. The shared parser is the single source of truth, removing the need to build this logic for each platform seperately. The same applies for the Zibs, they are generated from a shared JSON Schema to fix the same problems and have some consistency across platforms. 

## Usage

The FHIR Parser is a three step process.

### Split the FHIR Bundle into FHIR Resources

The parser can split a FHIR Bundle into an array of FHIR resources. The resulting array is of type **Any**. 

```swift
import FHIRParser

let json = """
{
  "resourceType": "Bundle",
  "id": "4f0c7257-c18e-4d3d-9c1e-aa2b2ed4ebb3",
  "meta": {
    "lastUpdated": "2024-04-15T06:52:57.148+00:00"
  }
  ...
"""
let data = Data(json.utf8)
let parser = FHIRParser()
let resources: [Data] = parser.splitBundleIntoResources(data)
```


### Transform a FHIR Resource into a Zib object

Each of the resources found by step 1 can be transformed into a Zib object. 

```swift
import FHIRParser
import Zibs

for element in resources {
			if let zib = parser.transformFHIRResourceIntoMGOResource(element, fhirVersion: "R3") {
 				// the Mgo Resource (as Data)       
      }
 }
```
We can transform the zib to a typed zib object
```swift
import FHIRParser
import Zibs

let zibMedicationUse = ZibFactory.createZibMedicationUse(zib)
```

The zib definitions are generated from a shared json schema, to be easily shared between the different platforms (web, iOS/swift, Android/Kotlin). That will prevent differences and errors between the platforms. 

### Transform a Zib object into a UISchema

Transforming that zib into a fixed UISchema is simple:
```swift
import FHIRParser
import Zibs

let summary = parser.getSummary(zib)
let details = parser.getDetails(zib)
```

The schema comes in two flavours: summary and details. The summary schema contains the most important fields and values, while the details contain all the fields and values of a zib.

The schema can be used to display the fields of a zib in a generic way, reducing the all the conditional and switching logic for the UI part. 

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/FHIRParser/LICENSE.txt) for details.
