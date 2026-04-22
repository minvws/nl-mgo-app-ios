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
		
		for groupedTable in dataSource.tables {
			guard !Task.isCancelled else { return nil }
			
			if groupedTable.shouldStartOnNewPage {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = PdfExport.Constants.outerMargin
			}
			
			appendGroupedTable(
				groupedTable,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
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
		let subHeading = factory.createPdfSubHeadingDrawElement(
			dataSource,
			yPosition: currentY
		)
		drawElements.append(subHeading)
		currentY += subHeading.height
		
		// Reserve space for the date column (+ 12pt gap) so the title never wraps into it
		let reservedWidth = subHeading.rect.width + 12
		let heading = factory.createPdfHeadingDrawElement(
			dataSource,
			yPosition: currentY,
			reservedTrailingWidth: reservedWidth
		)
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
		if var groupHeading = factory.createGroupedHeadingDrawElement(
			groupedTable,
			yPosition: currentY
		) {
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
		let hasHeading: Bool
		if var tableHeading = factory.createTableHeadingDrawElement(
			table,
			yPosition: currentY
		) {
			tableHeading.borderSides = [.top, .left, .right]
			append(
				&tableHeading,
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight
			)
			hasHeading = true
		} else {
			hasHeading = false
		}
		table.subTables.indices.forEach { index in
			appendSubTable(
				table.subTables[index],
				to: &drawElements,
				currentY: &currentY,
				availableHeight: availableHeight,
				isLastSubTable: index == table.subTables.count - 1,
				needsTopBorder: !hasHeading && index == 0
			)
		}
	}

	/// Append all draw elements for a single PdfSubTable
	private func appendSubTable(
		_ subTable: PdfSubTable,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		isLastSubTable: Bool,
		needsTopBorder: Bool = false
	) {
		if let heading = subTable.heading {
			var element = factory.createSubTableHeadingDrawElement(
				heading: heading,
				yPosition: currentY
			)
			element.borderSides = [.left, .right]
			if needsTopBorder {
				element.borderSides.insert(.top)
			}
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
				isLastInGroup: isLastSubTable && index == subTable.data.count - 1,
				needsTopBorder: needsTopBorder && subTable.heading == nil && index == 0
			)
		}
	}

	/// Append a key/value row pair with the correct border sides
	private func appendRow(
		_ pair: PdfSubTablePair,
		to drawElements: inout [PdfDrawElement],
		currentY: inout CGFloat,
		availableHeight: CGFloat,
		isLastInGroup: Bool,
		needsTopBorder: Bool = false
	) {
		var row = factory.createSubTableRowDrawElement(
			pair,
			yPosition: currentY
		)
		if row.count == 2 {
			row[0].borderSides = isLastInGroup ? [.left, .bottom] : [.left]
			row[1].borderSides = isLastInGroup ? [.right, .bottom] : [.right]
			if needsTopBorder {
				row[0].borderSides.insert(.top)
				row[1].borderSides.insert(.top)
			}
		} else if row.isNotEmpty {
			row[0].borderSides = isLastInGroup ? [.left, .right, .bottom] : [.left, .right]
			if needsTopBorder {
				row[0].borderSides.insert(.top)
			}
		}
		appendRowPair(
			&row,
			to: &drawElements,
			currentY: &currentY,
			availableHeight: availableHeight
		)
		if needsTopBorder {
			// .top changes topPadding from 6 → 12 in drawBorder, expanding the border rect by 6.
			// Advance by that extra 6 so the next row has the same 4pt overlap as normal rows.
			currentY += 6
		}
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
