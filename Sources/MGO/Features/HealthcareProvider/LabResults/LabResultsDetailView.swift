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
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		AccordionView(title: Sanitizer.strip(result.title) ?? "") {
			VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
				
				if let code = result.code {
					DetailRow(
						title: "labresults_details_code",
						content: code
					)
				}
				
				if let status = result.status {
					DetailRow(
						title: "labresults_details_status",
						content: status
					)
				}
				
				if let dateTime = result.dateTime {
					DetailRow(
						title: "labresults_details_dateTime",
						content: dateTime
					)
				}
				
				if let resultText = result.result {
					DetailRow(
						title: "labresults_details_result",
						content: resultText
					)
				}
				
				if let referenceRangeLow = result.referenceRangeLow {
					DetailRow(
						title: "labresults_details_referenceRangeLow",
						content: referenceRangeLow
					)
				}
				
				if let referenceRangeHigh = result.referenceRangeHigh {
					DetailRow(
						title: "labresults_details_referenceRangeHigh",
						content: referenceRangeHigh
					)
				}
				
				if let interpretation = result.interpretation {
					DetailRow(
						title: "labresults_details_interpretation",
						content: interpretation
					)
				}
				
				if let specimen = result.specimen {
					DetailRow(
						title: "labresults_details_specimen",
						content: specimen
					)
				}
				
				if let collectionDateTime = result.collectionDateTime {
					DetailRow(
						title: "labresults_details_collectionDateTime",
						content: collectionDateTime
					)
				}
			}
		}
	}
}
