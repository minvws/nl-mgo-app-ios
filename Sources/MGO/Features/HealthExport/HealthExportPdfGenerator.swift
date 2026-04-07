/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import PdfExport
import PDFKit

@MainActor
class HealthExportPdfGenerator {

	/// The PDF data source
	private let dataSource: PdfData

	/// The factory that creates the draw elements
	private let factory: PdfDrawElementFactory

	/// PDF document metadata
	private var metaData: [CFString: Any] {
		[
			kCGPDFContextTitle: dataSource.heading,
			kCGPDFContextSubject: String(localized: "export_pdf.footer"),
			kCGPDFContextCreator: String(localized: "common.app_name"),
			kCGPDFContextAllowsPrinting: true,
			kCGPDFContextAllowsCopying: true
		]
	}

	/// Create a PDF generator
	/// - Parameters:
	///   - dataSource: the PDF data to render
	///   - factory: the factory that creates draw elements
	init(
		dataSource: PdfData,
		factory: PdfDrawElementFactory = PdfDrawElementFactory(theme: .init())
	) {
		self.dataSource = dataSource
		self.factory = factory
	}

	/// Generate the PDF document
	/// - Returns: the rendered PDF document, or nil if rendering failed or cancelled
	func generatePDF() async -> PDFDocument? {

		var currentY: CGFloat = PdfExport.Constants.outerMargin
		var drawElements = [PdfDrawElement]()
		let footer = factory.createFooterElement(dataSource)
		let availableHeight = PdfExport.Constants.contentSize.height - footer.height - PdfExport.Constants.innerMargin

		drawElements.append(PdfDrawElement.pageBreak)
		appendPageHeader(to: &drawElements, currentY: &currentY)
		currentY += PdfExport.Constants.innerMargin

		for index in dataSource.tables.indices {
			guard !Task.isCancelled else { return nil }
			appendGroupedTable(
				dataSource.tables[index],
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
			if index < dataSource.tables.count - 1 {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = PdfExport.Constants.outerMargin
			}
			await Task.yield()
		}

		guard !Task.isCancelled else { return nil }
		return makePDFDocument(from: drawElements, footer: footer)
	}

	// MARK: - Page Layout

	/// Append the sub-heading and heading elements for the first page
	private func appendPageHeader(
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat
	) {
		// Creation Date — right-aligned overlay; height is 0 so currentY does not advance
		let subHeading = factory.createPdfSubHeadingDrawElement(dataSource, yPosition: currentY)
		drawElements.append(subHeading)
		currentY += subHeading.height
		let heading = factory.createPdfHeadingDrawElement(dataSource, yPosition: currentY)
		drawElements.append(heading)
		currentY += heading.height
	}

	/// Append all draw elements for a single PdfGroupedTable
	private func appendGroupedTable(
		_ groupedTable: PdfGroupedTables,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat
	) {
		var groupHeading = factory.createGroupedHeadingDrawElement(
			groupedTable,
			yPosition: currentY
		)
		append(
			&groupHeading,
			to: &drawElements,
			currentY: &currentY,
			availableHeight: availableHeight
		)

		guard !groupedTable.tables.isEmpty else {
			var empty = factory.createEmptySubCategoryDrawElement(
				String(localized: "export_pdf.no_data"),
				yPosition: currentY
			)
			append(
				&empty,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
			return
		}

		groupedTable.tables.forEach { table in
			appendTable(
				table,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
			currentY += PdfExport.Constants.innerMargin
		}
	}

	/// Append all draw elements for a single PdfTable
	private func appendTable(
		_ table: PdfTable,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat
	) {
		var tableHeading = factory.createTableHeadingDrawElement(
			table,
			yPosition: currentY
		)
		tableHeading.borderSides = [.top, .left, .right]
		append(
			&tableHeading,
			to: &drawElements,
			currentY: &currentY,
			availableHeight: availableHeight
		)

		table.subTables.indices.forEach { index in
			appendSubTable(
				table.subTables[index],
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				isLastSubTable: index == table.subTables.count - 1
			)
		}
	}

	/// Append all draw elements for a single PdfSubTable
	private func appendSubTable(
		_ subTable: PdfSubTable,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		isLastSubTable: Bool
	) {
		if let heading = subTable.heading {
			var element = factory.createSubTableHeadingDrawElement(
				heading: heading,
				yPosition: currentY
			)
			element.borderSides = [.left, .right]
			if isLastSubTable && subTable.data.isEmpty {
				element.borderSides.insert(.bottom)
			}
			append(
				&element,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
		}

		subTable.data.indices.forEach { index in
			appendRow(
				subTable.data[index],
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				isLastInGroup: isLastSubTable && index == subTable.data.count - 1
			)
		}
	}

	/// Append a key/value row pair with the correct border sides
	private func appendRow(
		_ pair: PdfSubTablePair,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		isLastInGroup: Bool
	) {
		var row = factory.createSubTableRowDrawElement(
			pair,
			yPosition: currentY
		)
		if row.count == 2 {
			row[0].borderSides = isLastInGroup ? [.left, .bottom] : [.left]
			row[1].borderSides = isLastInGroup ? [.right, .bottom] : [.right]
		} else if row.isNotEmpty {
			row[0].borderSides = isLastInGroup ? [.left, .right, .bottom] : [.left, .right]
		}
		appendRowPair(
			&row,
			to: &drawElements,
			currentY: &currentY,
			availableHeight: availableHeight
		)
	}

	/// Append a single draw element, inserting a page break first if needed
	private func append(
		_ element: inout PdfDrawElement,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat
	) {
		if currentY + element.height > availableHeight {
			drawElements.append(PdfDrawElement.pageBreak)
			currentY = PdfExport.Constants.outerMargin
			element.rect.origin.y = currentY
		}
		drawElements.append(element)
		currentY += element.height
	}

	/// Append a two-element row pair, inserting a page break first if needed
	private func appendRowPair(
		_ elements: inout [PdfDrawElement],
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat
	) {
		guard let rowHeight = elements.last?.height else { return }
		if currentY + rowHeight > availableHeight {
			drawElements.append(PdfDrawElement.pageBreak)
			currentY = PdfExport.Constants.outerMargin
			elements.indices.forEach { elements[$0].rect.origin.y = currentY }
		}
		drawElements.append(contentsOf: elements)
		currentY += rowHeight
	}

	// MARK: - Rendering

	/// Render draw elements into a PDF document
	private func makePDFDocument(
		from elements: [PdfDrawElement],
		footer: PdfDrawElement
	) -> PDFDocument? {

		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = metaData as [String: Any]

		let pdfRenderer = UIGraphicsPDFRenderer(
			bounds: CGRect(
				x: 0,
				y: 0,
				width: PdfExport.Constants.pageWidth,
				height: PdfExport.Constants.pageHeight
			),
			format: format
		)

		var currentPage: Int = 0
		let totalPages: Int = elements.filter { $0.isPageBreak == true }.count

		let data = pdfRenderer.pdfData { context in
			elements.forEach { drawElement in
				if drawElement.isPageBreak {
					handlePageBreak(
						context,
						currentPage: &currentPage,
						totalPages: totalPages,
						footer: footer
					)
				} else {
					drawElement.draw(context)
				}
			}
		}

		return PDFDocument(data: data)
	}

	/// Handle the page break
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - currentPage: the page we are currently drawing on
	///   - totalPages: the total number of pages
	///   - footer: the footer for each page
	private func handlePageBreak(
		_ context: UIGraphicsPDFRendererContext,
		currentPage: inout Int,
		totalPages: Int,
		footer: PdfDrawElement,
	) {
		context.beginPage()
		currentPage += 1
		footer.draw(context)
		factory.createPaginationElement(
			String(
				format: String(localized: "export_pdf.page"),
				arguments: ["\(currentPage)", "\(totalPages)"]
			)
		).draw(context)
	}
}
