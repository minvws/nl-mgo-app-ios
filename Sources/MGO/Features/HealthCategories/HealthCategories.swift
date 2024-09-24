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
		case allergies = 2
		case measurements = 3
		case vaccinations = 4
		case complaints = 5
		case treatments = 6
		case labresults = 7
		case reports = 8
		case documents = 9
		
		/// Which of the Nictiz profiles do we accept for a category?
		var acceptedProfiles: [String] {
			switch self {
				
				case .medication:
					[
						ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue,
						ZibMedicationAgreementProfile.httpNictizNlFhirStructureDefinitionZibMedicationAgreement.rawValue,
						ZibAdministrationAgreementProfile.httpNictizNlFhirStructureDefinitionZibAdministrationAgreement.rawValue
					]
				
				case .complaints:
					[
						ZibProblemProfile.httpNictizNlFhirStructureDefinitionZibProblem.rawValue
					]
				
				case .allergies:
					[
						ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue
					]
					
				default: []
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
