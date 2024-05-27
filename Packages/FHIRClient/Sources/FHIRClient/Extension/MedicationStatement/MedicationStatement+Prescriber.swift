/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension MedicationStatement {
	
	/// Who prescribed this medication?
	public var prescriber: String? {
		// See https://github.com/apple/FHIRModels/blob/main/HowTo/Extensions.md
		guard let ext = self.extensions(for: "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse-Prescriber").first else { return nil }
		
		if case .reference(let ref) = ext.value {
			return ref.display?.value?.string
		}
		return nil
	}
}
