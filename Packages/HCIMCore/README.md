# HCIM Core

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
| [Gp Diagnostic Result](Sources/HCIMCore/HCIM/Generated/GpDiagnosticResult.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/1.3.4/files/113377 |
| [Gp Encounter](Sources/HCIMCore/HCIM/Generated/GpEncounter.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316991 |
| [Gp Encounter Report](Sources/HCIMCore/HCIM/Generated/GpEncounterReport.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316993 |
| [Gp Journal Entry](Sources/HCIMCore/HCIM/Generated/GpJournalEntry.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316995 |
| [Gp Laboratory Result](Sources/HCIMCore/HCIM/Generated/GpLaboratoryResult.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316997 |

| Ihe Mhd Minimal Document (R3) | Definition |
| -- | -- |
| [Ihe Mhd Minimal Document Manifest](Sources/HCIMCore/HCIM/Generated/IheMhdMinimalDocumentManifest.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317001 |
| [Ihe Mhd Minimal Document Reference](Sources/HCIMCore/HCIM/Generated/IheMhdMinimalDocumentReference.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317003 |

| NL Core (R3) | Definition |
| -- | -- |
| [Nl Core Care Plan](Sources/HCIMCore/HCIM/Generated/NlCoreCarePlan.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.3.1/files/2980598 |
| [Nl Core Care Team](Sources/HCIMCore/HCIM/Generated/NlCoreCareTeam.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.20/files/2741659 |
| [Nl Core Episode Of Care](Sources/HCIMCore/HCIM/Generated/NlCoreEpisodeOfCare.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317023 |
| [Nl Core Location](Sources/HCIMCore/HCIM/Generated/NlCoreLocation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317029 |
| [Nl Core Observation](Sources/HCIMCore/HCIM/Generated/NlCoreObservation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317032 |
| [Nl Core Organization](Sources/HCIMCore/HCIM/Generated/NlCoreOrganization.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317033 |
| [Nl Core Patient](Sources/HCIMCore/HCIM/Generated/NlCorePatient.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317041 |
| [Nl Core Practitioner](Sources/HCIMCore/HCIM/Generated/NlCorePractitioner.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317041 |
| [Nl Core Practitioner Role](Sources/HCIMCore/HCIM/Generated/NlCorePractitionerRole.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317053 |
| [Nl Core Related Person](Sources/HCIMCore/HCIM/Generated/NlCoreRelatedPerson.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317060 |

| NL Core (R4) | Definition |
| -- | -- |
| [Nl Core Healtcare Provider](Sources/HCIMCore/HCIM/Generated/R4NlCoreHealtcareProvider.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946116 |
| [Nl Core Healthcare Provider Organization](Sources/HCIMCore/HCIM/Generated/R4NlCoreHealthcareProviderOrganization.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946118|
| [Nl Core Health Professional Practitioner](Sources/HCIMCore/HCIM/Generated/R4NlCoreHealthProfessionalPractitioner.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946120|
| [Nl Core Health Professional Practitioner Role](Sources/HCIMCore/HCIM/Generated/R4NlCoreHealthProfessionalPractitionerRole.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/2628465|
| [Nl Core Patient](Sources/HCIMCore/HCIM/Generated/R4NlCorePatient.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946199|
| [Nl Core Pharmaceutical Product](Sources/HCIMCore/HCIM/Generated/R4NlCorePharmaceuticalProduct.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946208|
| [Nl Core Vaccination Event](Sources/HCIMCore/HCIM/Generated/R4NlCoreVaccinationEvent.swift) | https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.8.0-beta.1/files/1946266|

| Zib (R3) | Definition |
| --- | -- |
| [E Afspraak Appointment](Sources/HCIMCore/HCIM/Generated/EAfspraakAppointment.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.eafspraak/1.0.6/files/714361/ |
| [Zib Administration Agreement](Sources/HCIMCore/HCIM/Generated/ZibAdministrationAgreement.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317124 |
| [Zib Advance Directive](Sources/HCIMCore/HCIM/Generated/ZibAdvanceDirective.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317129 |
| [Zib Alcohol Use](Sources/HCIMCore/HCIM/Generated/ZibAlcoholUse.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317134 |
| [Zib Alert](Sources/HCIMCore/HCIM/Generated/ZibAlert.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317136 |
| [Zib Allergy Intolerance](Sources/HCIMCore/HCIM/Generated/ZibAllergyIntolerance.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317138 |
| [Zib Blood Pressure](Sources/HCIMCore/HCIM/Generated/ZibBloodPressure.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317147 |
| [Zib Body Height](Sources/HCIMCore/HCIM/Generated/ZibBodyHeight.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317149 |
| [Zib Body Weight](Sources/HCIMCore/HCIM/Generated/ZibBodyWeight.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317153 |
| [Zib Drug Use](Sources/HCIMCore/HCIM/Generated/ZibDrugUse.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317175 |
| [Zib Encounter](Sources/HCIMCore/HCIM/Generated/ZibEncounter.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317177 |
| [Zib Family Situation](Sources/HCIMCore/HCIM/Generated/ZibFamilySituation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.20/files/2741820 |
| [Zib Functional Or Mental Status](Sources/HCIMCore/HCIM/Generated/ZibFunctionalOrMentalStatus.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317206 |
| [Zib General Measurement](Sources/HCIMCore/HCIM/Generated/ZibGeneralMeasurement.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317209 |
| [Zib Help From Others](Sources/HCIMCore/HCIM/Generated/ZibHelpFromOthers.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.3.1/files/2980662 |
| [Zib Laboratory Test Result Observation](Sources/HCIMCore/HCIM/Generated/ZibLaboratoryTestResultObservation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317239 |
| [Zib Laboratory Test Result Specimen](Sources/HCIMCore/HCIM/Generated/ZibLaboratoryTestResultSpecimen.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317241 |
| [Zib Laboratory Test Result Specimen Isolate](Sources/HCIMCore/HCIM/Generated/ZibLaboratoryTestResultSpecimenIsolate.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317243 |
| [Zib Laboratory Test Result Substance](Sources/HCIMCore/HCIM/Generated/ZibLaboratoryTestResultSubstance.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317246 |
| [Zib Living Situation](Sources/HCIMCore/HCIM/Generated/ZibLivingSituation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317251 |
| [Zib Medical Device](Sources/HCIMCore/HCIM/Generated/ZibMedicalDevice.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317253 |
| [Zib Medical Device Product](Sources/HCIMCore/HCIM/Generated/ZibMedicalDeviceProduct.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317259 |
| [Zib Medical Device Request](Sources/HCIMCore/HCIM/Generated/ZibMedicalDeviceRequest.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317263 |
| [Zib Medication Agreement](Sources/HCIMCore/HCIM/Generated/ZibMedicationAgreement.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317273 |
| [Zib Medication Use](Sources/HCIMCore/HCIM/Generated/ZibMedicationUse.swift) |  https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317279 |
| [Zib Nutrition Advice](Sources/HCIMCore/HCIM/Generated/ZibNutritionAdvice.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317294 |
| [Zib Participation In Society](Sources/HCIMCore/HCIM/Generated/ZibParticipationInSociety.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.3.1/files/2980686/ |
| [Zib Payer](Sources/HCIMCore/HCIM/Generated/ZibPayer.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317307 |
| [Zib Problem](Sources/HCIMCore/HCIM/Generated/ZibProblem.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317327 |
| [Zib Procedure](Sources/HCIMCore/HCIM/Generated/ZibProcedure.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317337 |
| [Zib Procedure Request](Sources/HCIMCore/HCIM/Generated/ZibProcedureRequest.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317340 |
| [Zib Product](Sources/HCIMCore/HCIM/Generated/ZibProduct.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317343 |
| [Zib Text Result](Sources/HCIMCore/HCIM/Generated/ZibTextResult.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317374 |
| [Zib Tobacco Use](Sources/HCIMCore/HCIM/Generated/ZibTobaccoUse.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317376 |
| [Zib Treatment Directive](Sources/HCIMCore/HCIM/Generated/ZibTreatmentDirective.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317378 |
| [Zib Treatment Objective](Sources/HCIMCore/HCIM/Generated/ZibTreatmentObjective.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.3.1/files/2980713 |
| [Zib Vaccination](Sources/HCIMCore/HCIM/Generated/ZibVaccination.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317388 |
| [Zib Vaccination Recommendation](Sources/HCIMCore/HCIM/Generated/ZibVaccinationRecommendation.swift) | https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317390 |

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
