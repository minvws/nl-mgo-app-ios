/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import PdfExport
@testable import MGO

@Suite
struct UIElementPdfMappingTests {

	// MARK: - DownloadLink

	@Test("DownloadLink getPdfMapping returns download style with label as value")
	func downloadLink_mapping() throws {

		// Given
		let element = DownloadLink(id: "1", label: "Bijlage rapport.pdf", type: .downloadLink, url: nil)

		// When
		let pair = try #require(element.getPdfMapping())

		// Then
		#expect(pair.style == .download)
		#expect(pair.value == "Bijlage rapport.pdf")
		#expect(pair.key == "")
	}

	// MARK: - DownloadBinary

	@Test("DownloadBinary getPdfMapping returns download style with label as value")
	func downloadBinary_mapping() throws {

		// Given
		let element = DownloadBinary(id: "1", label: "Scan resultaat.pdf", reference: nil, type: .downloadBinary)

		// When
		let pair = try #require(element.getPdfMapping())

		// Then
		#expect(pair.style == .download)
		#expect(pair.value == "Scan resultaat.pdf")
		#expect(pair.key == "")
	}
}
