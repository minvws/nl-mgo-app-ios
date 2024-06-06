/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRExtensions

public class LaboratoryTestResultDecorator {
	
	public static func create(_ observation: Observation, bundle: ModelsSTU3.Bundle) -> MgoLaboratoryTestResult? {
		
		guard let title = observation.categoryText else { return nil }
		
		let specimen: Specimen? = observation.resolve(observation.specimen, from: bundle)
		
		return MgoLaboratoryTestResult(
			title: title,
			code: observation.codeText,
			status: observation.status.value?.rawValue,
			dateTime: observation.effectiveDate,
			result: observation.quantityText,
			referenceRangeLow: observation.referenceLowText,
			referenceRangeHigh: observation.referenceHighText,
			interpretation: observation.interpretationText,
			specimen: specimen?.name,
			collectionDateTime: specimen?.collectedDate
		)
	}
}
