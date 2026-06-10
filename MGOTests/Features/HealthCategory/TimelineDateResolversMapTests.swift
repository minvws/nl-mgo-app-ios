/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
import MGOFoundation
@testable import MGO

@MainActor
struct TimelineDateResolversMapTests {

	// MARK: - Profile lookup

	@Test("Unsupported profile returns nil")
	func unsupportedProfile_returnsNil() {

		// Given
		let data = HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z")

		// When
		let resolver = TimelineDateResolversMap.make(
			profile: "http://example.com/fhir/StructureDefinition/Unknown",
			data: data
		)

		// Then
		#expect(resolver == nil)
	}

	@Test("Empty data returns nil")
	func emptyData_returnsNil() {

		// Given
		let data = Data()

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.iheMhdProfile, data: data)

		// Then
		#expect(resolver == nil)
	}

	@Test("Malformed JSON returns nil")
	func malformedJson_returnsNil() {

		// Given
		let data = Data("not-json".utf8)

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.iheMhdProfile, data: data)

		// Then
		#expect(resolver == nil)
	}

	@Test("Profile mismatch between caller and payload returns nil")
	func profileMismatch_returnsNil() {

		// Given — payload declares the IheMhd profile, caller asks for the BBS profile
		let data = HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z")

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.bbsProfile, data: data)

		// Then
		#expect(resolver == nil)
	}

	// MARK: - IheMhdMinimalDocumentReference

	@Test("IheMhd payload with indexed exposes timelineDateValue")
	func iheMhd_withIndexed_exposesTimelineDate() {

		// Given
		let data = HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z")

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.iheMhdProfile, data: data)

		// Then
		#expect(resolver is IheMhdMinimalDocumentReference)
		let expected = ISO8601DateFormatter().date(from: "2026-04-22T08:30:00Z")
		#expect(resolver?.timelineDateValue == expected)
	}

	@Test("IheMhd payload without indexed has nil timelineDateValue")
	func iheMhd_withoutIndexed_returnsNilTimelineDate() {

		// Given
		let data = HCIMGenerator.iheMhdJson(indexedValue: nil)

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.iheMhdProfile, data: data)

		// Then
		#expect(resolver is IheMhdMinimalDocumentReference)
		#expect(resolver?.timelineDateValue == nil)
	}

	@Test("IheMhd payload with unparsable indexed has nil timelineDateValue")
	func iheMhd_withUnparsableIndexed_returnsNilTimelineDate() {

		// Given
		let data = HCIMGenerator.iheMhdJson(indexedValue: "not-a-date")

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.iheMhdProfile, data: data)

		// Then
		#expect(resolver is IheMhdMinimalDocumentReference)
		#expect(resolver?.timelineDateValue == nil)
	}

	// MARK: - R4BBSDocumentReference

	@Test("BBS payload with date exposes timelineDateValue")
	func bbs_withDate_exposesTimelineDate() {

		// Given
		let data = HCIMGenerator.bbsJson(dateValue: "2026-03-15")

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.bbsProfile, data: data)

		// Then
		#expect(resolver is R4BBSDocumentReference)
		#expect(resolver?.timelineDateValue != nil)
	}

	@Test("BBS payload without date has nil timelineDateValue")
	func bbs_withoutDate_returnsNilTimelineDate() {

		// Given
		let data = HCIMGenerator.bbsJson(dateValue: nil)

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.bbsProfile, data: data)

		// Then
		#expect(resolver is R4BBSDocumentReference)
		#expect(resolver?.timelineDateValue == nil)
	}

	@Test("BBS payload with unparsable date has nil timelineDateValue")
	func bbs_withUnparsableDate_returnsNilTimelineDate() {

		// Given
		let data = HCIMGenerator.bbsJson(dateValue: "not-a-date")

		// When
		let resolver = TimelineDateResolversMap.make(profile: HCIMGenerator.bbsProfile, data: data)

		// Then
		#expect(resolver is R4BBSDocumentReference)
		#expect(resolver?.timelineDateValue == nil)
	}
}
