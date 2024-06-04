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
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		AccordionView(title: Sanitizer.strip(statement.title) ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				if let dosageText = Sanitizer.strip(statement.instructions) {
					DetailRow(title: "medication_details_dosage", content: dosageText)
				}
				if let startDate = Sanitizer.strip(statement.startDate) {
					DetailRow(title: "medication_details_startdate", content: startDate)
				}
				if let prescriber = Sanitizer.strip(statement.prescribedBy) {
					DetailRow(title: "medication_details_prescriber", content: prescriber)
				}
				if let printDescription = Sanitizer.strip(statement.status) {
					DetailRow(title: "medication_details_status", content: printDescription)
				}
			}
		}
	}
}
