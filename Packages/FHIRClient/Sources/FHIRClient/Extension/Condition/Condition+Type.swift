/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {
	
	// See https://zibs.nl/wiki/Probleem-v4.1(2017NL)#ProbleemTypeCodelijst
	// And https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2316863
	
	// Various condition types
	public enum ConditionType {
		case diagnose
		case symptom
		case complaint
		case functionalLimitation
		case complication
	}
	
	/// What kind of condition is this?
	public var conditionType: ConditionType? {
		
		guard let firstCoding = category?.first?.coding?.first,
				firstCoding.system == "http://snomed.info/sct" else {
			return nil
		}
		
		switch firstCoding.code?.value?.string {
			
			case "282291009": return .diagnose
				
			case "41879908": return .symptom
				
			case "409586006": return .complaint
				
			case "248566006": return .functionalLimitation
				
			case "116223007": return .complication
				
			case .none: return nil
				
			default: return nil
		}
	}
}
