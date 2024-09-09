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
			profile: ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse,
			reasonCode: nil,
			reasonForChangeOrDiscontinuationOfUse: nil,
			referenceID: "1",
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
}
