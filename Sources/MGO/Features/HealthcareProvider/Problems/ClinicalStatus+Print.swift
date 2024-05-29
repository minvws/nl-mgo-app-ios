/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */


import MGOFoundation

extension Condition.ClinicalStatus {
	
	public var printDescription: String {
		
		switch self {
	
			case .active: String(localized: "condition_status_active")
			case .inactive: String(localized: "condition_status_inactive")
		}
	}
}
