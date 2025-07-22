# Shared Core

## Overview

A shared Javascript FHIR -> HCIM parser.

This parser is written in Javascript (Typescript) and is used for the web, iOS and Android application. The shared parser is the single source of truth, removing the need to build this logic for each platform seperately. The same applies for the HCIMs, they are generated from a shared JSON Schema to fix the same problems and have some consistency across platforms. 

## Usage

The HCIM parser is a three step process.

### Split the FHIR Bundle into FHIR Resources

The parser can split a FHIR Bundle into an array of FHIR resources. The resulting array is of type **Any**. 

```swift
import HCIMParser

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


### Transform a FHIR Resource into a HCIM resource

Each of the resources found by step 1 can be transformed into a HCIM resource. 

```swift
import HCIMParser

for element in resources {
	if let hcim = parser.transformFHIRResourceIntoMGOResource(element, fhirVersion: "R3") {
		// the Mgo Resource (as Data)       
	}
}
```
We can transform the hcim resource to a typed hcim object
```swift
import HCIMParser

let zibMedicationUse = HCIMFactory.createZibMedicationUse(hcim)
```

The hcim definitions are generated from a shared json schema, to be easily shared between the different platforms (web, iOS/swift, Android/Kotlin). That will prevent differences and errors between the platforms. 

### Transform a HCIM object into a HealthUISchema

Transforming that hcim into a fixed HealthUISchema is simple:
```swift
import HCIMParser

let summary = parser.getSummary(hcim)
let details = parser.getDetails(hcim)
```

The schema comes in two flavours: summary and details. The summary schema contains the most important fields and values, while the details contain all the fields and values of a hcim.

The schema can be used to display the fields of a hcim in a generic way, reducing the all the conditional and switching logic for the UI part. 

### HCIMs

| GP (R3) | Definition |
| -- | -- |
| [Gp Diagnostic Result](Sources/SharedCore/HCIM/Generated/GpDiagnosticResult) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/1.3.4/files/113377 |
| [Gp Encounter](Sources/SharedCore/HCIM/Generated/GpEncounter) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316991 |
| [Gp Encounter Report](Sources/SharedCore/HCIM/Generated/GpEncounterReport) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316993 |
| [Gp Journal Entry](Sources/SharedCore/HCIM/Generated/GpJournalEntry) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316995 |
| [Gp Laboratory Result](Sources/SharedCore/HCIM/Generated/GpLaboratoryResult) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316997 |

| Ihe Mhd Minimal Document (R3) | Definition |
| -- | -- |
| [Ihe Mhd Minimal Document Manifest](Sources/SharedCore/HCIM/Generated/IheMhdMinimalDocumentManifest) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317001 |
| [Ihe Mhd Minimal Document Reference](Sources/SharedCore/HCIM/Generated/IheMhdMinimalDocumentReference) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317003 |

| NL Core (R3) | Definition |
| -- | -- |
| [Nl Core Observation](Sources/SharedCore/HCIM/Generated/NlCoreObservation) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317032 |
| [Nl Core Organization](Sources/SharedCore/HCIM/Generated/NlCoreOrganization) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317033 |
| [Nl Core Patient](Sources/SharedCore/HCIM/Generated/NlCorePatient) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317041 |
| [Nl Core Practitioner](Sources/SharedCore/HCIM/Generated/NlCorePractitioner) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317041 |
| [Nl Core Practitioner Role](Sources/SharedCore/HCIM/Generated/NlCorePractitionerRole) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317053 |

| NL Core (R4) | Definition |
| -- | -- |
| [Nl Core Healtcare Provider](Sources/SharedCore/HCIM/Generated/R4NlCoreHealtcareProvider) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946116 |
| [Nl Core Health Professional Practitioner](Sources/SharedCore/HCIM/Generated/R4NlCoreHealthProfessionalPractitioner) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946120|
| [Nl Core Health Professional Practitioner Role](Sources/SharedCore/HCIM/Generated/R4NlCoreHealthProfessionalPractitionerRole) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/2628465|
| [Nl Core Healthcare Provider Organization](Sources/SharedCore/HCIM/Generated/R4NlCoreHealthcareProviderOrganization) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946118|
| [Nl Core Patient](Sources/SharedCore/HCIM/Generated/R4NlCorePatient) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946199|
| [Nl Core Pharmaceutical Product](Sources/SharedCore/HCIM/Generated/R4NlCorePharmaceuticalProduct) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946208|
| [Nl Core Vaccination Event](Sources/SharedCore/HCIM/Generated/R4NlCoreVaccinationEvent) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946266|

| Zib (R3) | Definition |
| --- | -- |
| [E Afspraak Appointment](Sources/SharedCore/HCIM/Generated/EAfspraakAppointment) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.eafspraak/1.0.6/files/714361/ |
| [Zib Administration Agreement](Sources/SharedCore/HCIM/Generated/ZibAdministrationAgreement) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317124 |
| [Zib Advance Directive](Sources/SharedCore/HCIM/Generated/ZibAdvanceDirective) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317129 |
| [Zib Alcohol Use](Sources/SharedCore/HCIM/Generated/ZibAlcoholUse) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317134 |
| [Zib Alert](Sources/SharedCore/HCIM/Generated/ZibAlert) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317136 |
| [Zib Allergy Intolerance](Sources/SharedCore/HCIM/Generated/ZibAllergyIntolerance) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317138 |
| [Zib Blood Pressure](Sources/SharedCore/HCIM/Generated/ZibBloodPressure) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317147 |
| [Zib Body Height](Sources/SharedCore/HCIM/Generated/ZibBodyHeight) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317149 |
| [Zib Body Weight](Sources/SharedCore/HCIM/Generated/ZibBodyWeight) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317153 |
| [Zib Drug Use](Sources/SharedCore/HCIM/Generated/ZibDrugUse) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317175 |
| [Zib Encounter](Sources/SharedCore/HCIM/Generated/ZibEncounter) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317177 |
| [Zib Functional Or Mental Status](Sources/SharedCore/HCIM/Generated/ZibFunctionalOrMentalStatus) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317206 |
| [Zib Laboratory Test Result Observation](Sources/SharedCore/HCIM/Generated/ZibLaboratoryTestResultObservation) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317239 |
| [Zib Laboratory Test Result Specimen](Sources/SharedCore/HCIM/Generated/ZibLaboratoryTestResultSpecimen) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317241 |
| [Zib Laboratory Test Result Specimen Isolate](Sources/SharedCore/HCIM/Generated/ZibLaboratoryTestResultSpecimenIsolate) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317243 |
| [Zib Laboratory Test Result Substance](Sources/SharedCore/HCIM/Generated/ZibLaboratoryTestResultSubstance) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317246 |
| [Zib Living Situation](Sources/SharedCore/HCIM/Generated/ZibLivingSituation) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317251 |
| [Zib Medical Device](Sources/SharedCore/HCIM/Generated/ZibMedicalDevice) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317253 |
| [Zib Medical Device Product](Sources/SharedCore/HCIM/Generated/ZibMedicalDeviceProduct) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317259 |
| [Zib Medical Device Request](Sources/SharedCore/HCIM/Generated/ZibMedicalDeviceRequest) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317263 |
| [Zib Medication Agreement](Sources/SharedCore/HCIM/Generated/ZibMedicationAgreement) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317273 |
| [Zib Medication Use](Sources/SharedCore/HCIM/Generated/ZibMedicationUse) |  https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317279 |
| [Zib Nutrition Advice](Sources/SharedCore/HCIM/Generated/ZibNutritionAdvice) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317294 |
| [Zib Payer](Sources/SharedCore/HCIM/Generated/ZibPayer) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317307 |
| [Zib Problem](Sources/SharedCore/HCIM/Generated/ZibProblem) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317327 |
| [Zib Procedure](Sources/SharedCore/HCIM/Generated/ZibProcedure) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317337 |
| [Zib Procedure Request](Sources/SharedCore/HCIM/Generated/ZibProcedureRequest) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317340 |
| [Zib Product](Sources/SharedCore/HCIM/Generated/ZibProduct) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317343 |
| [Zib Tobacco Use](Sources/SharedCore/HCIM/Generated/ZibTobaccoUse) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317376 |
| [Zib Treatment Directive](Sources/SharedCore/HCIM/Generated/ZibTreatmentDirective) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317378 |
| [Zib Vaccination](Sources/SharedCore/HCIM/Generated/ZibVaccination) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317388 |
| [Zib Vaccination Recommendation](Sources/SharedCore/HCIM/Generated/ZibVaccinationRecommendation) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317390 |

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios-private?tab=License-1-ov-file#readme) for details.
