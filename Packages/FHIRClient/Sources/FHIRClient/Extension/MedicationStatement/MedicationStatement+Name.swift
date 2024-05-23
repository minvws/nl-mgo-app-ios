/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension MedicationStatement {
	
	/// What is the name of this medication
	public var medicationName: String? {
		
		if case .reference(let ref) = self.medication {
			return ref.display?.value?.string
		}
		if case .codeableConcept(let cc) = self.medication {
			return cc.text?.value?.string
		}
		return nil
	}
}
