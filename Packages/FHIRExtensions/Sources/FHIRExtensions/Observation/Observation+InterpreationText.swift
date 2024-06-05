/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Observation {
	
	public var interpretationText: String? {
		
		return interpretation?.coding?.first { $0.system == "http://snomed.info/sct" }?.display?.value?.string
	}
}
