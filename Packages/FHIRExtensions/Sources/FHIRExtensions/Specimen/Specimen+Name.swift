/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Specimen {
	
	/// When was this specimen collected
	public var collectedDate: String? {
		
		if case .period(let period) = self.collection?.collected {
			return period.start?.value?.date.description
		}
		if case .dateTime(let dateTime) = self.collection?.collected {
			return dateTime.value?.description
		}
		return nil
	}
}
