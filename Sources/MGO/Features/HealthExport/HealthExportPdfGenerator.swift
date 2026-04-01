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
	private let metaData = [
		kCGPDFContextAuthor: String(localized: "common.app_name"),
		kCGPDFContextSubject: String(localized: "export_pdf.footer"),
		kCGPDFContextAllowsPrinting: true,
		kCGPDFContextAllowsCopying: true
	] as [CFString: Any]

	/// Create a PDF generator
	/// - Parameter dataSource: the PDF data to render
	init(dataSource: PdfData) {
		self.dataSource = dataSource
		self.factory = PdfDrawElementFactory(theme: .init())
	}

	/// Generate the PDF document
	/// - Returns: the rendered PDF document, or nil if rendering failed
	func generatePDF() -> PDFDocument? {

		var currentY: CGFloat = PdfExport.Constants.outerMargin
		var drawElements = [PdfDrawElement]()
		let footer = factory.createFooterElement(dataSource)
		let availableHeight = PdfExport.Constants.contentSize.height - footer.height - PdfExport.Constants.innerMargin

		drawElements.append(PdfDrawElement.pageBreak)
		appendPageHeader(to: &drawElements, currentY: &currentY)
		currentY += PdfExport.Constants.innerMargin

		dataSource.tables.forEach { groupedTable in
			appendGroupedTable(
				groupedTable,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
			if groupedTable != dataSource.tables.last {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = PdfExport.Constants.outerMargin
			}
		}

		return makePDFDocument(from: drawElements, footer: footer)
	}

	// MARK: - Supporting Types

	/// Identifies which element in a PdfGroupedTable receives the bottom border
	private struct BorderContext {
		let lastPair: PdfSubTablePair?
		let lastSubTableHeading: PdfSubTable?
		let isTableHeading: Bool
	}

	// MARK: - Page Layout

	/// Append the sub-heading and heading elements for the first page
	private func appendPageHeader(
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat
	) {
		// Creation Date
		drawElements.append(factory.createPdfSubHeadingDrawElement(
			dataSource,
			yPosition: currentY)
		)
		currentY += drawElements.last?.height ?? 0
		drawElements.append(factory.createPdfHeadingDrawElement(
			dataSource,
			yPosition: currentY)
		)
		currentY += drawElements.last?.height ?? 0
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

		let context = borderContext(for: groupedTable)

		groupedTable.tables.forEach { table in
			appendTable(
				table,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				borderContext: context,
				isLastTable: table == groupedTable.tables.last
			)
			currentY += PdfExport.Constants.innerMargin
		}
	}

	/// Pre-compute which element in a group receives the bottom border
	nonisolated private func borderContext(for groupedTable: PdfGroupedTables) -> BorderContext {
		let lastPair = groupedTable.tables.last?.subTables.reversed().lazy.compactMap { $0.data.last }.first
		let lastSubTableHeading = lastPair == nil
		? groupedTable.tables.last?.subTables.reversed().first(where: { $0.heading != nil })
		: nil
		return BorderContext(
			lastPair: lastPair,
			lastSubTableHeading: lastSubTableHeading,
			isTableHeading: lastPair == nil && lastSubTableHeading == nil
		)
	}

	/// Append all draw elements for a single PdfTable
	private func appendTable(
		_ table: PdfTable,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		borderContext: BorderContext,
		isLastTable: Bool
	) {
		var tableHeading = factory.createTableHeadingDrawElement(
			table,
			yPosition: currentY
		)
		tableHeading.borderSides = [.top, .left, .right]
		if borderContext.isTableHeading && isLastTable {
			tableHeading.borderSides.insert(.bottom)
		}
		append(
			&tableHeading,
			to: &drawElements,
			currentY: &currentY,
			availableHeight: availableHeight
		)

		table.subTables.forEach { subTable in
			appendSubTable(
				subTable,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				borderContext: borderContext
			)
		}
	}

	/// Append all draw elements for a single PdfSubTable
	private func appendSubTable(
		_ subTable: PdfSubTable,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		borderContext: BorderContext
	) {
		if let heading = subTable.heading {
			var element = factory.createSubTableHeadingDrawElement(
				heading: heading,
				yPosition: currentY
			)
			element.borderSides = [.left, .right]
			if subTable == borderContext.lastSubTableHeading {
				element.borderSides.insert(.bottom)
			}
			append(
				&element,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
		}

		subTable.data.forEach { pair in
			appendRow(
				pair,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				isLastInGroup: pair == borderContext.lastPair
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
		row[0].borderSides = isLastInGroup ? [.left, .bottom] : [.left]
		row[1].borderSides = isLastInGroup ? [.right, .bottom] : [.right]
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
		if currentY + (elements.last?.height ?? 0) > availableHeight {
			drawElements.append(PdfDrawElement.pageBreak)
			currentY = PdfExport.Constants.outerMargin
			elements.indices.forEach { elements[$0].rect.origin.y = currentY }
		}
		drawElements.append(contentsOf: elements)
		currentY += elements.last?.height ?? 0
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
				}
				drawElement.draw(context)
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
