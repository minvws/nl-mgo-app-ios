/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct LabResultsDetailView: View {
	
	/// The  lab result
	var result: MgoLaboratoryTestResult
	
	/// Should we start in an open State?
	var startOpen: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		AccordionView(title: Sanitizer.strip(result.title) ?? "", startOpen: startOpen) {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				DetailRow(title: "labresults_details_code", content: Sanitizer.strip(result.code))
				
				DetailRow(title: "labresults_details_status", content: Sanitizer.strip(result.status))
				
				DetailRow(title: "labresults_details_dateTime", content: Sanitizer.strip(result.dateTime))
				
				DetailRow(title: "labresults_details_result", content: Sanitizer.strip(result.result))
				
				DetailRow(title: "labresults_details_referenceRangeLow", content: Sanitizer.strip(result.referenceRangeLow))
				
				DetailRow(title: "labresults_details_referenceRangeHigh", content: Sanitizer.strip(result.referenceRangeHigh))
				
				DetailRow(title: "labresults_details_interpretation", content: Sanitizer.strip(result.interpretation))
				
				DetailRow(title: "labresults_details_specimen", content: Sanitizer.strip(result.specimen))
				
				DetailRow(title: "labresults_details_collectionDateTime", content: Sanitizer.strip(result.collectionDateTime))
			}
		}
	}
}
