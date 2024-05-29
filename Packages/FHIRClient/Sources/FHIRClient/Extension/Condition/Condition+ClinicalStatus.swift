/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {
	
	// See https://zibs.nl/wiki/Probleem-v4.1(2017NL)#ProbleemStatusCodelijst
	// And https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316957
	
	// Various clinical status
	public enum ClinicalStatus {
		case active
		case inactive
	}
	
	/// What kind of condition is this?
	public var status: ClinicalStatus? {
		
		switch clinicalStatus?.value?.string {
			
			case "active", "recurrence": return .active
				
			case "inactive", "remission", "resolved": return .inactive
				
			default: return nil
		}
	}
}
