/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

struct HealthCategories {
	
	enum Category: Int, CaseIterable, Codable {
		case medication = 1
		case measurements = 2
		case labresults = 3
		case allergies = 4
		case treatments = 5
		case appointments = 6
		case vaccinations = 7
		case documents = 8
		case complaints = 9
		case patient = 10
		case alerts = 11
		case payment = 12
		case plans = 13
		case devices = 14
		case mental = 15
		case lifestyle = 16
		
		/// Which of the Nictiz profiles do we accept for a category?
		var acceptedProfiles: [String] {
			switch self {
				
				case .medication:
					[
						ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue,
						ZibMedicationAgreementProfile.httpNictizNlFhirStructureDefinitionZibMedicationAgreement.rawValue,
						ZibAdministrationAgreementProfile.httpNictizNlFhirStructureDefinitionZibAdministrationAgreement.rawValue
					]
				
				case .measurements: []
				case .labresults: []
				
				case .allergies:
					[
						ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue
					]
				case .treatments: []
				case .appointments: []
				case .vaccinations: []
				case .documents: []
				
				case .complaints:
					[
						ZibProblemProfile.httpNictizNlFhirStructureDefinitionZibProblem.rawValue
					]
				
				case .patient: []
				case .alerts: []
				case .payment: []
				case .plans: []
				case .devices: []
				case .mental: []
				case .lifestyle: []
			}
		}
		
		/// What endpoints should we use for a category?
		var endPoint: [(DVP.Endpoint, Int)] {
			switch self {
				case .medication: [
					(DVP.CommonClinicalDataset.medicationUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.medicationAgreement, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.currentMedication, DVP.GeneralPractitioner.serviceID),
					(DVP.CommonClinicalDataset.administrationAgreement, DVP.CommonClinicalDataset.serviceID)
				]
				case .allergies: [
					(DVP.CommonClinicalDataset.allergyIntolerance, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.allergyIntolerance, DVP.GeneralPractitioner.serviceID)
				]
				case .complaints: [
					(DVP.CommonClinicalDataset.problem, DVP.CommonClinicalDataset.serviceID)
				]
				default: []
			}
		}
	}
}
