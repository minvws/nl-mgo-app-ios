# FHIR Extensions

## Overview

This package contains helper extensions to get certain fields from the (verbose and complicated) FHIR classes.

## Usage

### Condition

- locationType (which part of the body: Left, Right, Left and Right)
- location (which part of the body)
- startDate (when did this condition start)
- endDate (when did this condition end)
- name (what is the name of this condition)
- note (concatinated notes)

### Contact Point

- The ContactPoint is now equatable and comparable (sortable)
- The ContactPointUse is now equatable and comparable (sortable)

### Observation
- categoryText
- codeText
- effectiveDate
- interpretationText
- quantityText
- referenceLowText
- referenceHighText

### Patient
- email (The the primary email address of the patient)
- humanName (Easy way to retrieve a string for the patient's name, with a preference for the "usual" use name.)

### Resource
- fromJSON (decode from JSON)
- resolve (resolves a reference within the same bundle)

### Specimen
- collectedDate (When was this specimen collected)
- name (What is the name of this specimen?)


## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/LICENSE.txt) for details.
