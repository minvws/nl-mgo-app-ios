/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct LabResultsDetailView: View {
	
	/// The  concern
	var concern: MgoConcern
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		AccordionView(title: Sanitizer.strip(concern.title) ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				if let conditionType = concern.type {
					DetailRow(
						title: "condition_details_type",
						content: conditionType
					)
				}
				
				if let status = concern.status {
					DetailRow(
						title: "condition_details_status",
						content: status
					)
				}
		
				DetailRow(
					title: "condition_details_startdate",
					content: Sanitizer.strip(concern.startDate) ?? String(localized: "general_unknown")
				)
				
				DetailRow(
					title: "condition_details_enddate",
					content: Sanitizer.strip(concern.endDate) ?? String(localized: "general_unknown")
				)
				
				if let location = Sanitizer.strip(concern.bodyLocation) {
					DetailRow(
						title: "condition_details_location",
						content: location
					)
				}
				
				if let noteText = Sanitizer.strip(concern.comment) {
					DetailRow(
						title: "condition_details_note",
						content: noteText
					)
				}
			}
		}
	}
}
