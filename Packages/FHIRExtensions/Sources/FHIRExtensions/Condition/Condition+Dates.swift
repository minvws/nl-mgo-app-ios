/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {

	/// When did this condition start?
	public var startDate: String? {
		
		if case .dateTime(let dateTime) = self.onset {
			return dateTime.value?.description
		}
		return nil
	}
	
	/// When did this condition end?
	public var endDate: String? {
		
		if case .dateTime(let dateTime) = self.abatement {
			return dateTime.value?.description
		}
		return nil
	}
}
