/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Builders for raw HCIM JSON payloads used as `MgoResource` test fixtures.
///
/// Tests that exercise FHIR-profile dispatch (e.g. `TimelineDateResolversMap`)
/// need minimally valid HCIM JSON for specific profiles. Constructing those
/// inline pollutes the test, so the shapes live here behind small, named
/// builders that toggle just the fields each test cares about.
enum HCIMGenerator {

	static let iheMhdProfile = "http://nictiz.nl/fhir/StructureDefinition/IHE.MHD.Minimal.DocumentReference"
	static let bbsProfile = "http://medmij.nl/fhir/StructureDefinition/bbs-DocumentReference"

	/// Build a minimal `IheMhdMinimalDocumentReference` JSON payload.
	/// Pass `nil` for `indexedValue` to omit the `indexed` field entirely.
	static func iheMhdJson(indexedValue: String?) -> Data {

		var fields: [String] = [
			"\"context\": {}",
			"\"fhirVersion\": \"R3\"",
			"\"profile\": \"\(iheMhdProfile)\"",
			"\"referenceId\": \"DocumentReference/ihe-mhd-test\"",
			"\"resourceType\": \"DocumentReference\""
		]
		if let indexedValue {
			fields.append("\"indexed\": { \"_type\": \"instant\", \"value\": \"\(indexedValue)\" }")
		}
		return Data("{ \(fields.joined(separator: ", ")) }".utf8)
	}

	/// Build a minimal `R4BBSDocumentReference` JSON payload.
	/// Pass `nil` for `dateValue` to omit the `date` field entirely.
	static func bbsJson(dateValue: String?) -> Data {

		var fields: [String] = [
			"\"context\": {}",
			"\"fhirVersion\": \"R4\"",
			"\"profile\": \"\(bbsProfile)\"",
			"\"referenceId\": \"DocumentReference/bbs-test\"",
			"\"resourceType\": \"DocumentReference\""
		]
		if let dateValue {
			fields.append("\"date\": { \"_type\": \"dateTime\", \"value\": \"\(dateValue)\" }")
		}
		return Data("{ \(fields.joined(separator: ", ")) }".utf8)
	}
}
