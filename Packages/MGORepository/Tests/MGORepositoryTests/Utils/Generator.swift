/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGORepository
import FHIRExtensions

public class MockGenerator {
	
	public static func concern() -> MgoConcern {
		
		return MgoConcern(
			title: "Fractuur van pols (aandoening)",
			type: "diagnose",
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
	
	public static func medicationUse() -> MgoMedicationUse {
		
		return MgoMedicationUse(
			
			title: "Zestril tablet 10mg",
			instructions: "1 maal per dag 1 tablet, oraal",
			prescribedBy: "Huisartsen, niet nader gespecificeerd",
			startDate: "2018-06-28",
			status: "active"
		)
	}
}
