/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import PDFKit

public struct PDFKitView: UIViewRepresentable {
	
	/// The PDF Document
	private let document: PDFDocument
	
	/// Create a PDFKit SwiftUI view
	/// - Parameter document: the pdf document
	public init(_ document: PDFDocument) {
		self.document = document
	}
	
	/// UIViewRepresentable method to create a pdf view
	/// - Parameter context: the context
	/// - Returns: PDF View
	public func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()
		pdfView.document = document
		pdfView.pageShadowsEnabled = false
		pdfView.autoScales = true
		pdfView.backgroundColor = UIColor(ViewTheme().primaryBackground)
		pdfView.displayMode = .singlePageContinuous
		return pdfView
	}
	
	/// UIViewRepresentable method to update the view
	/// - Parameters:
	///   - pdfView: the pdf view to update
	///   - context: the context
	public func updateUIView(_ pdfView: PDFView, context: Context) {
		pdfView.document = document
	}
}

public struct PDFUIView: View {

	/// The PDF Document
	let document: PDFDocument
	
	/// Create a PDF View
	/// - Parameter document: pdf document
	public init(_ document: PDFDocument) {
		self.document = document
	}
	
	/// Get the body for this view
	public var body: some View {
		PDFKitView(document)
	}
}
