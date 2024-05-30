/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct ProblemDetailView: View {
	
	/// The  condition 
	var condition: MGO.Condition
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		AccordionView(title: Sanitizer.strip(condition.title) ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				if let conditionType = condition.type {
					DetailRow(
						title: "condition_details_type",
						content: conditionType
					)
				}
				
				if let status = condition.status {
					DetailRow(
						title: "condition_details_status",
						content: status
					)
				}
		
				DetailRow(
					title: "condition_details_startdate",
					content: Sanitizer.strip(condition.startDate) ?? String(localized: "general_unknown")
				)
				
				DetailRow(
					title: "condition_details_enddate",
					content: Sanitizer.strip(condition.endDate) ?? String(localized: "general_unknown")
				)
				
				if let location = Sanitizer.strip(condition.bodyLocation) {
					DetailRow(
						title: "condition_details_location",
						content: location
					)
				}
				
				if let noteText = Sanitizer.strip(condition.comment) {
					DetailRow(
						title: "condition_details_note",
						content: noteText
					)
				}
			}
		}
	}
}
