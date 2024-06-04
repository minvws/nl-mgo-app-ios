/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRExtensions

public class ConcernDecorator {
	
	public static func create(_ condition: Condition) -> MgoConcern? {
		
		guard let title = condition.name else { return nil }
		
		var location: String? {
			
			guard var unwrapped = condition.location else { return nil }
			if let locationType = condition.locationType {
				unwrapped += ", \(locationType)"
			}
			return unwrapped
		}
		
		return MgoConcern(
			title: title,
			type: condition.conditionType?.rawValue,
			clinicalStatus: condition.status?.rawValue,
			startDate: condition.startDate,
			endDate: condition.endDate,
			bodyLocation: location,
			comment: condition.noteText
		)
	}
}
