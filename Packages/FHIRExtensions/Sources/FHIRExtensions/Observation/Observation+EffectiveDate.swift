/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Observation {
	
	/// When should we start taking this medication?
	public var effectiveDate: String? {
		
		if case .period(let period) = self.effective {
			return period.start?.value?.date.description
		}
		if case .dateTime(let dateTime) = self.effective {
			return dateTime.value?.description
		}
		return nil
	}
}
