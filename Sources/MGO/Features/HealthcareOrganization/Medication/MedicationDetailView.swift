/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct MedicationDetailView: View {
	
	/// The medication use
	var statement: MgoMedicationUse
	
	/// Should we start in an open State?
	var startOpen: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		AccordionView(title: Sanitizer.strip(statement.title) ?? "", startOpen: startOpen) {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				DetailRow(title: "fhir.instructions", content: Sanitizer.strip(statement.instructions))
				
				DetailRow(title: "fhir.startDate", content: Sanitizer.strip(statement.startDate))
				
				DetailRow(title: "fhir.prescribedBy", content: Sanitizer.strip(statement.prescribedBy))
				
				DetailRow(title: "fhir.medicationStatus", content: Sanitizer.strip(statement.status))
			}
		}
	}
}
