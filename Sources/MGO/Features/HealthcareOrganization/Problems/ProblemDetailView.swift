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
	
	/// Should we start in an open State?
	var startOpen: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		AccordionView(title: Sanitizer.strip(concern.title) ?? "", startOpen: startOpen) {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				DetailRow(title: "fhir.category", content: Sanitizer.strip(concern.category))
				
				DetailRow(title: "fhir.clinicalStatus", content: Sanitizer.strip(concern.clinicalStatus))
				
				DetailRow(title: "fhir.startDate", content: Sanitizer.strip(concern.startDate))
				
				DetailRow(title: "fhir.endDate", content: Sanitizer.strip(concern.endDate))
				
				DetailRow(title: "fhir.bodyLocation", content: Sanitizer.strip(concern.bodyLocation))
				
				DetailRow(title: "fhir.comment", content: Sanitizer.strip(concern.comment))
			}
		}
	}
}
