/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

class Generator {
	
	/// Create a healthcare provider
	/// - Parameters:
	///   - id: the identifier of the provider
	///   - city: the city of the provider
	///   - address: the address of the provider
	///   - postalCode: the postal code of the provider
	/// - Returns: a healthcare provider
	static func healthcareProvider(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareProvider {
		return HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			identification_type: "type",
			identification_value: id,
			active: true,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
			names: [],
			types: [
				Components.Schemas.CType(
					code: "01",
					display_name: "Tandarts",
					_type: ""
				)
			],
			data_services: []
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
	
	static func medicationUse() -> MgoMedicationUse {
		
		return MgoMedicationUse(
			
			title: "Zestril tablet 10mg",
			instructions: "1 maal per dag 1 tablet, oraal",
			prescribedBy: "Huisartsen, niet nader gespecificeerd",
			startDate: "2018-06-28",
			status: "active"
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
