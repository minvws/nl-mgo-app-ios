/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

enum MGO {
	// Name Space for mapped FHIR classes to MGO display classes
	
}

extension MGO {
	
	//
	struct Condition: Codable {
		
		var title: String
		
		var type: String?
		
		var status: String?
		
		var startDate: String?
		
		var endDate: String?
		
		var bodyLocation: String?
		
		var comment: String?
	}
}

class ConditionDecorator {
	
	static func create(_ condition: Condition) -> MGO.Condition? {
		
		guard let title = condition.name else { return nil }
		
		var location: String? {
			
			guard var unwrapped = condition.location else { return nil }
			if let locationType = condition.locationType {
				unwrapped += ", \(locationType)"
			}
			return unwrapped
		}
		
		return MGO.Condition(
			title: title,
			type: condition.conditionType?.rawValue,
			status: condition.status?.rawValue,
			startDate: condition.startDate,
			endDate: condition.endDate,
			bodyLocation: location,
			comment: condition.noteText
		)
	}
}
