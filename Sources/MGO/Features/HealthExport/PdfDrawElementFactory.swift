/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/**
 * Factory to create draw elements from pdf data
 */
public class PdfDrawElementFactory {
	
	/// The theme
	private var theme: ExportTheme
	
	/// Create a PDF draw elements factory
	/// - Parameter theme: the visual theme
	public init(theme: ExportTheme) {
		self.theme = theme
	}
	
	// MARK: - Create Methods
	
	/// Create a draw element for the heading
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw element for the heading
	@MainActor public func createPdfHeadingDrawElement(
		_ pdfData: PdfData,
		currentY: CGFloat,
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: pdfData.heading,
			attributes: [
				.font: UIFont.helveticaBold(24) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: currentY,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight
		)
	}
	
	/// Create a draw element for the sub heading
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw element for the sub heading
	@MainActor public func createPdfSubHeadingDrawElement(
		_ pdfData: PdfData,
		currentY: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: pdfData.subHeading,
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textBox = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		)
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin + HealthExport.Constants.contentSize.width - textBox.width,
				y: currentY,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}
	
	/// Create a draw element for the heading for grouped tables
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw element for the grouped tables heading
	@MainActor public func createGroupedHeadingDrawElement(
		_ tables: PdfGroupedTables,
		currentY: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: tables.heading,
			attributes: [
				.font: UIFont.helveticaBold(16) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil).height + 12
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: currentY,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight
		)
	}
	
	/// Create a draw element for the heading for a table
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw element for a table
	@MainActor public func createTableHeadingDrawElement(
		_ table: PdfTable,
		currentY: CGFloat,
	) -> PdfDrawElement {
		
		let style = NSMutableParagraphStyle()
		style.alignment = NSTextAlignment.center
		
		let text = NSAttributedString(
			string: table.heading,
			attributes: [
				.font: UIFont.helveticaBold(12) as Any,
				.foregroundColor: UIColor(theme.primaryText),
				.paragraphStyle: style
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: currentY,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight + 11
		)
	}
	
	/// Create a draw element for the heading for a sub table
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw element for a sub table
	@MainActor public func createSubTableHeadingDrawElement(
		heading: String,
		currentY: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: heading,
			attributes: [
				.font: UIFont.helveticaBold(10) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: currentY,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight + 11
		)
	}
	
	/// Create the draw elements for the heading for a sub table key value pair
	/// - Parameters:
	///   - pair: key value pair
	///   - currentY: the  y-position to draw from
	/// - Returns: PDF draw elements for a sub table key value pair
	@MainActor public func createSubTableRowDrawElement(
		_ pair: PdfSubTablePair,
		currentY: CGFloat
	) -> [PdfDrawElement] {
		
		let keyText = NSAttributedString(
			string: pair.key,
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let valueText = NSAttributedString(
			string: pair.value,
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let keyHeight = keyText.boundingRect(
			with: CGSize(width: (HealthExport.Constants.contentSize.width / 2) - 12, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		let valueHeight = valueText.boundingRect(
			with: CGSize(width: (HealthExport.Constants.contentSize.width / 2) - 12, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		let textHeight = max(keyHeight, valueHeight)
		
		return [
			PdfDrawElement(
				text: keyText,
				backgroundColor: theme.secondaryBackground,
				borderColor: theme.border,
				rect: CGRect(
					x: HealthExport.Constants.outerMargin,
					y: currentY,
					width: HealthExport.Constants.contentSize.width / 2,
					height: textHeight
				),
				height: textHeight + 11
			),
			PdfDrawElement(
				text: valueText,
				backgroundColor: nil,
				borderColor: theme.border,
				rect: CGRect(
					x: HealthExport.Constants.outerMargin + (HealthExport.Constants.contentSize.width / 2) - 1,
					y: currentY,
					width: (HealthExport.Constants.contentSize.width / 2) + 1,
					height: textHeight
				),
				height: textHeight + 11
			)
		]
	}
	
	/// Get the PDF draw element for the footer
	/// - Parameter pdfData: the pdf data
	/// - Returns: footer PDF draw element
	@MainActor public func createFooterElement(_ pdfData: PdfData) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: pdfData.footer,
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: HealthExport.Constants.contentSize.height - textHeight,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight
		)
	}
	
	/// Create a PDF draw element for pagination
	/// - Parameters:
	///   - currentPage: the page we are currently on
	///   - totalPages: the total number of pages
	/// - Returns: pdf draw element for the pagination
	@MainActor public func createPaginationElement(currentPage: Int, totalPages: Int) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: String(
				format: String(localized: "export_pdf.page"),
				arguments: ["\(currentPage)", "\(totalPages)"]
			),
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textBox = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		)
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin + HealthExport.Constants.contentSize.width - textBox.width,
				y: HealthExport.Constants.contentSize.height - textBox.height,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}
	
	/// Create a PDF draw element for an empty sub category
	/// - Parameters:
	///   - currentY: the  y-position to draw from
	/// - Returns: pdf draw element for an empty sub category
	@MainActor public func createEmptySubCategoryDrawElement(currentY: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: String(localized: "export_pdf.no_data"),
			attributes: [
				.font: UIFont.helvetica(10) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: HealthExport.Constants.contentSize.width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(
				x: HealthExport.Constants.outerMargin,
				y: currentY,
				width: HealthExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight
		)
	}
}
