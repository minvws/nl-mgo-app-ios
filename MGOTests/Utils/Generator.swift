/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

class Generator {
	
	/// Create a healthcare organization
	/// - Parameters:
	///   - id: the identifier of the organization
	///   - city: the city of the organization
	///   - address: the address of the organization
	///   - postalCode: the postal code of the organization
	/// - Returns: a healthcare organization
	static func healthcareOrganization(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB", useDataService: Bool = true ) -> MgoOrganization {
		
		var dataServices = [LocalisationService.Components.Schemas.ZalDataServiceResponse]()
		if useDataService {
			dataServices.append(
				LocalisationService.Components.Schemas.ZalDataServiceResponse(
					id: 48,
					name: "Basisgegevens Zorg",
					interface_version: 2,
					auth_endpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/authorize",
					token_endpoint: "https://medmij-inlog.vzvz.nl/2.0.0/oauth2/token",
					roles: [
						LocalisationService.Components.Schemas.ZalDataServiceRoleResponse(
							code: "MM-3.0-BZB-FHIR",
							resource_endpoint: "https://dva-mock.test.mgo.prolocation.net/48")
					]
				)
			)
		}
		
		return MgoOrganization(
			display_name: "Tandarts Tandje Erbij",
			identification_type: "type",
			identification_value: id,
			active: true,
			addresses: [LocalisationService.Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
			names: [],
			types: [
				LocalisationService.Components.Schemas.CType(
					code: "01",
					display_name: "Tandarts",
					_type: ""
				)
			],
			data_services: dataServices
		)
	}
	
	// MARK: - Concern
	
	static func concern() -> MgoConcern {
		
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
	
	// MARK: - MedicationUse
	
	static func medicationUse() -> ZibMedicationUse {
		
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
	
	// MARK: - LabResult
	
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
