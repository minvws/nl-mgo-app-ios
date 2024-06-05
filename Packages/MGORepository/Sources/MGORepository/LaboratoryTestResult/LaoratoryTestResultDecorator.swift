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

extension Resource {
	
	func resolve<T: Resource>(_ reference: Reference?, from bundle: ModelsSTU3.Bundle) -> T? {
		
		guard let ref = reference?.reference?.value?.string else { return nil }
		let elements = ref.components(separatedBy: "/")
		guard elements.count == 2 else { return nil }
		let type = elements[0]
		let key = elements[1]
		
		guard String(describing: T.self) == type else { return nil }
		
		let targets: [T] = bundle.entry?.compactMap {
			$0.resource?.get(if: T.self)
		} ?? []
		let result = targets.filter { $0.id?.value?.string == key }
		return result.first
	}
}
