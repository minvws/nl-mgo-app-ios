/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct MedicationDetailView: View {
	
	/// The medication statement (STU3)
	var statement: MedicationStatement
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		AccordionView(title: statement.medicationName ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				if let dosageText = statement.dosageText {
					DetailRow(title: "medication_details_dosage", content: dosageText)
				}
				if let startDate = statement.startDate {
					DetailRow(title: "medication_details_startdate", content: startDate)
				}
				if let endDate = statement.endDate {
					DetailRow(title: "medication_details_enddate", content: endDate)
				}
				if let prescriber = statement.prescriber {
					DetailRow(title: "medication_details_prescriber", content: prescriber)
				}
				if let printDescription = statement.status.value?.printDescription {
					DetailRow(title: "medication_details_status", content: printDescription)
				}
			}
		}
	}
}
