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
				
				DetailRow(title: "fhir.code", content: Sanitizer.strip(result.code))
				
				DetailRow(title: "fhir.status", content: Sanitizer.strip(result.status))
				
				DetailRow(title: "fhir.dateTime", content: Sanitizer.strip(result.dateTime))
				
				DetailRow(title: "fhir.result", content: Sanitizer.strip(result.result))
				
				DetailRow(title: "fhir.referenceRangeLow", content: Sanitizer.strip(result.referenceRangeLow))
				
				DetailRow(title: "fhir.referenceRangeHigh", content: Sanitizer.strip(result.referenceRangeHigh))
				
				DetailRow(title: "fhir.interpretation", content: Sanitizer.strip(result.interpretation))
				
				DetailRow(title: "fhir.specimen", content: Sanitizer.strip(result.specimen))
				
				DetailRow(title: "fhir.collectionDateTime", content: Sanitizer.strip(result.collectionDateTime))
			}
		}
	}
}
