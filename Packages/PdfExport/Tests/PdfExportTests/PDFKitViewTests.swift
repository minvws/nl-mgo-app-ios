/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import PdfExport

final class PDFKitViewTests: XCTestCase {
	
	@MainActor func test_view() throws {
		
		// Given
		let document = PDFDocument()
		let sut = PDFUIView(document)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: view, as: .image(perceptualPrecision: 0.95))
	}
}
