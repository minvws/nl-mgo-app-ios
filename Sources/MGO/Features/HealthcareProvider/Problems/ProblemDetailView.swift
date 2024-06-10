/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct ProblemDetailView: View {
	
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
				
				DetailRow(title: "condition_details_type", content: Sanitizer.strip(concern.category))
				
				DetailRow(title: "condition_details_status", content: Sanitizer.strip(concern.clinicalStatus))
				
				DetailRow(title: "condition_details_startdate", content: Sanitizer.strip(concern.startDate))
				
				DetailRow(title: "condition_details_enddate", content: Sanitizer.strip(concern.endDate))
				
				DetailRow(title: "condition_details_location", content: Sanitizer.strip(concern.bodyLocation))
				
				DetailRow(title: "condition_details_note", content: Sanitizer.strip(concern.comment))
			}
		}
	}
}
