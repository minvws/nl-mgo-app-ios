/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGORepository
import FHIRExtensions
import Zibs

public class MockGenerator {
	
	public static func concern() -> MgoConcern {
		
		return MgoConcern(
			title: "Fractuur van pols (aandoening)",
			category: "diagnose",
			clinicalStatus: "inactive",
			startDate: "2001",
			endDate: "2001",
			bodyLocation: "Gehele polsregio (lichaamsstructuur), Rechts",
			comment: "Gevallen op kunstijsbaan."
		)
	}
	
	public static func condition() -> ModelsSTU3.Condition {
		
		return ModelsSTU3.Condition(
			abatement: .dateTime("2024"),
			assertedDate: "2024-05-30",
			bodySite: [
				CodeableConcept(
					coding: [
						Coding(
							code: "361289009",
							display: "Entire wrist region",
							system: "http://snomed.info/sct"
						)
					],
					extension: [
						Extension(
							url: FHIRPrimitive<FHIRURI>(stringLiteral: "http://nictiz.nl/fhir/StructureDefinition/BodySite-Qualifier"),
							value: .codeableConcept(
								CodeableConcept(
									coding: [
										Coding(
											code: "24028007",
											display: "Right",
											system: "http://snomed.info/sct"
										)
									]
								)
							)
						)
					]
				)
			],
			category: [
				CodeableConcept(
					coding: [
						Coding(
							code: "409586006",
							display: "Complaint",
							system: "http://snomed.info/sct"
						)
					]
				)
			],
			clinicalStatus: "active",
			code: CodeableConcept(
				coding: [
					Coding(
						code: "31641000146105",
						display: "Fracture of wrist (disorder)",
						system: "http://snomed.info/sct"
					)
				]
			),
			note: [Annotation(text: "comment")],
			onset: .dateTime("2024-01-02"),
			subject: Reference(display: "Johan XXX_Helleman", reference: "Patient/nl-core-patient-01")
		)
	}
	
	public static func medicationStatement() -> ModelsSTU3.MedicationStatement {
		
		return MedicationStatement(
			dosage: [
				Dosage(
					text: "Vanaf 22 februari 2024, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, oraal"
				)
			],
			effective: .period(Period(start: FHIRPrimitive<DateTime>("2024-02-21"))),
			medication: .reference(
				Reference(
					display: "PARACETAMOL TABLET 500MG",
					reference: "Medication/zib-Product-02"
				)
			),
			status: FHIRPrimitive<MedicationStatementStatus>(.active),
			subject: Reference(
				display: "Johan XXX_Helleman",
				reference: "Patient/nl-core-patient-01"
			),
			taken: FHIRPrimitive<MedicationStatementTaken>(.unk)
		)
	}
	
	public static func medicationUse() -> ZibMedicationUse {
		
		return ZibMedicationUse(
			asAgreedIndicator: true,
			author: nil,
			category: [
				MgoCoding(
					code: "6",
					display: "Medicatiegebruik",
					system: "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
				)
			],
			dateAsserted: "2018-08-16",
			dosage: [
				ZibInstructionsForUse(
					additionalInstruction: nil,
					asNeeded: nil,
					doseQuantity: MgoQuantity(
						code: "245",
						comparator: nil,
						system: "urn:oid:2.16.840.1.113883.2.4.4.1.900.2",
						unit: "stuk",
						value: 1
					),
					doseRange: nil,
					maxDosePerPeriod: nil,
					rateQuantity: nil,
					rateRange: nil,
					rateRatio: nil,
					timing: ZibAdministrationSchedule(
						dayOfWeek: nil,
						duration: nil,
						durationUnit: nil,
						frequency: nil,
						frequencyMax: nil,
						period: 1,
						periodUnit: "d",
						timeOfDay: nil,
						when: nil
					)
				)
			],
			effectiveDuration: MgoQuantity(
				code: "wk",
				comparator: nil,
				system: "http://unitsofmeasure.org",
				unit: "week",
				value: 3
			),
			effectivePeriod: MgoPeriod(end: nil, start: "2018-06-28"),
			id: "cafa8f45-74bc-4107-a6f8-6eb58c6ed670",
			identifier: [
				MgoIdentifier(
					system: "http://example-implementer.com/fhir/MedicationUseID",
					type: nil,
					use: nil,
					value: "123457000000"
				)
			],
			informationSource: MgoReference(
				display: "Johan XXX_Helleman",
				reference: "Patient/93cde269-ce35-4077-a39d-19296670e949"
			),
			medication: MgoReference(
				display: "Zestril tablet 10mg",
				reference: "Medication/8f017a48-fdab-42f5-a2d7-f7bb6d84a762"
			),
			medicationTreatment: nil,
			note: [
				MgoAnnotation(
					author: nil,
					text: "MGO Mock Object",
					time: nil
				)
			],
			prescriber: MgoReference(
				display: "Huisartsen, niet nader gespecificeerd",
				reference: "PractitionerRole/1a249336-3fe7-488f-bc88-44bc8e1ad2aa"
			),
			profile: "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse",
			reasonCode: nil,
			reasonForChangeOrDiscontinuationOfUse: nil,
			repeatPeriodCyclicalSchedule: nil,
			resourceType: "MedicationStatement",
			status: "active",
			subject: MgoReference(
				display: "Johan XXX_Helleman",
				reference: "Patient/93cde269-ce35-4077-a39d-19296670e949"
			),
			taken: "y"
		)
	}
	
	static func labResult() -> MgoLaboratoryTestResult {
		
		return MgoLaboratoryTestResult(
			title: "Bevinding betreffende laboratoriumonderzoek (bevinding)",
			code: "Chloride [mol/volume] in bloed",
			status: "final",
			dateTime: "2012-05-23T12:00:00+02:00",
			result: "109 mmol/l",
			referenceRangeLow: "99 mmol/l",
			referenceRangeHigh: "108 mmol/l",
			interpretation: "boven referentiebereik (kwalificatiewaarde)",
			specimen: "Bloed (substantie)",
			collectionDateTime: "2012-05-23T08:08:00+02:00"
		)
	}
}
