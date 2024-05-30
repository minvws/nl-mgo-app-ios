/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {
	
	/// What kind of condition is this?
	public var locationType: String? {
		
		guard let ext = self.bodySite?.first?.extensions(for: "http://nictiz.nl/fhir/StructureDefinition/BodySite-Qualifier").first else { return nil }
		
		if case .codeableConcept(let concept) = ext.value {
			return concept.coding?.first?.display?.value?.string
		}
		
		return nil
	}
	
	public var location: String? {
		
		return bodySite?.first?.coding?.first?.display?.value?.string
	}
}
