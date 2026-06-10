/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
@testable import FHIRClient

@Suite struct FHIRClientUnitTests {

	// MARK: - init(baseURL:)

	@Test("Initializer appends a trailing slash when the base URL is missing one")
	func init_appendsTrailingSlashWhenMissing() async {
		let client = FHIRClient(baseURL: URL(string: "https://example.com/fhir")!)
		let baseURL = await client.baseURL
		#expect(baseURL.absoluteString.hasSuffix("/"))
	}

	@Test("Initializer preserves a trailing slash that is already present")
	func init_preservesExistingTrailingSlash() async {
		let client = FHIRClient(baseURL: URL(string: "https://example.com/fhir/")!)
		let baseURL = await client.baseURL
		#expect(baseURL.absoluteString == "https://example.com/fhir/")
	}

	// MARK: - absoluteURL(for:)

	@Test("absoluteURL encodes pipe characters as %7C")
	func absoluteURL_encodesPipeCharacters() async {
		let client = FHIRClient(baseURL: URL(string: "https://example.com/")!)
		let url = await client.absoluteURL(for: "Observation?category=foo|bar")
		let urlString = url?.absoluteString ?? ""
		#expect(urlString.contains("%7C"))
		#expect(!urlString.contains("|"))
	}

	@Test("absoluteURL resolves a relative path against the base URL")
	func absoluteURL_resolvesRelativePath() async {
		let client = FHIRClient(baseURL: URL(string: "https://example.com/fhir/")!)
		let url = await client.absoluteURL(for: "Patient/123")
		#expect(url?.absoluteString == "https://example.com/fhir/Patient/123")
	}
}
