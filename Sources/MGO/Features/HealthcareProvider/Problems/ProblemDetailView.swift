/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct ProblemDetailView: View {
	
	/// The  condition (STU3)
	var condition: Condition
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var location: String? {
		
		guard var sanitized = Sanitizer.strip(condition.location) else { return nil }
		if let locationType = condition.locationType {
			sanitized += ", \(locationType)"
		}
		return sanitized
	}
	
	var body: some View {
		
		AccordionView(title: Sanitizer.strip(condition.name) ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				if let conditionType = condition.conditionType?.printDescription {
					DetailRow(
						title: "condition_type",
						content: conditionType
					)
				}
				
				if let status = condition.status?.printDescription {
					DetailRow(
						title: "condition_status",
						content: status
					)
				}
				
				DetailRow(
					title: "medication_details_startdate",
					content: Sanitizer.strip(condition.startDate) ?? String(localized: "general_unknown")
				)
				
				DetailRow(
					title: "medication_details_enddate",
					content: Sanitizer.strip(condition.endDate) ?? String(localized: "general_unknown")
				)
				
				if let location {
					DetailRow(
						title: "condition_location",
						content: location
					)
				}
				
				if let noteText = Sanitizer.strip(condition.noteText) {
					DetailRow(
						title: "condition_details_note",
						content: noteText
					)
				}
			}
		}
	}
}
