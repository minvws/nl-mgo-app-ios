/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/**
 * Factory to create draw elements from pdf data
 */
@MainActor public class PdfDrawElementFactory {

	/// The theme
	private var theme: ExportTheme

	// Common bounding size for attributed text measurement
	private let boundingSize = CGSize(
		width: PdfExport.Constants.contentSize.width,
		height: .greatestFiniteMagnitude
	)

	// Common half-width bounding size for sub table measurements
	private let halfWidthBoundingSize = CGSize(
		width: (PdfExport.Constants.contentSize.width / 2) - 12,
		height: .greatestFiniteMagnitude
	)

	/// Create a PDF draw elements factory
	/// - Parameter theme: the visual theme
	public init(theme: ExportTheme) {
		self.theme = theme
	}

	// MARK: - Create Methods

	/// Create a draw element for the heading
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw element for the heading
	public func createPdfHeadingDrawElement(
		_ pdfData: PdfData,
		yPosition: CGFloat,
	) -> PdfDrawElement {
		
		let text = attributed(
			pdfData.heading,
			font: .helveticaBold(24),
			color: theme.primaryText
		)
		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: nil,
			yPosition: yPosition,
			textHeight: textHeight
		)
	}

	/// Create a draw element for the sub heading
	/// - Parameters:
	///   - pdfData: the pdf data
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw element for the sub heading
	public func createPdfSubHeadingDrawElement(
		_ pdfData: PdfData,
		yPosition: CGFloat
	) -> PdfDrawElement {
		
		let text = attributed(
			pdfData.subHeading,
			font: .helvetica(10),
			color: theme.secondaryText
		)
		let textBox = text.measure(in: boundingSize)
		return PdfDrawElement(
			text: text,
			borderColor: nil,
			rect: CGRect(
				x: PdfExport.Constants.outerMargin + PdfExport.Constants.contentSize.width - textBox.width,
				y: yPosition,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}

	/// Create a draw element for the heading for grouped tables
	/// - Parameters:
	///   - tables: the grouped tables
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw element for the grouped tables heading
	public func createGroupedHeadingDrawElement(
		_ tables: PdfGroupedTables,
		yPosition: CGFloat
	) -> PdfDrawElement {
		
		let text = attributed(
			tables.heading,
			font: .helveticaBold(16),
			color: theme.primaryText
		)
		let textHeight = text.height(in: boundingSize) + 16
		return fullWidthElement(
			text: text,
			borderColor: nil,
			yPosition: yPosition,
			textHeight: textHeight
		)
	}

	/// Create a draw element for the heading for a table
	/// - Parameters:
	///   - table: the table
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw element for a table
	public func createTableHeadingDrawElement(
		_ table: PdfTable,
		yPosition: CGFloat,
	) -> PdfDrawElement {
		
		let text = attributed(
			table.heading,
			font: .helveticaBold(14),
			color: theme.primaryText
		)
		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: theme.border,
			yPosition: yPosition,
			textHeight: textHeight,
			heightOffset: 18
		)
	}

	/// Create a draw element for the heading for a sub table
	/// - Parameters:
	///   - heading: the content to draw (String)
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw element for a sub table
	public func createSubTableHeadingDrawElement(
		heading: String,
		yPosition: CGFloat
	) -> PdfDrawElement {
		
		let text = attributed(
			heading,
			font: .helveticaBold(12),
			color: theme.primaryText
		)
		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: theme.border,
			yPosition: yPosition,
			textHeight: textHeight,
			heightOffset: 8
		)
	}

	/// Create the draw elements for the heading for a sub table key value pair
	/// - Parameters:
	///   - pair: key value pair
	///   - yPosition: the  y-position to draw from
	/// - Returns: PDF draw elements for a sub table key value pair
	public func createSubTableRowDrawElement(
		_ pair: PdfSubTablePair,
		yPosition: CGFloat
	) -> [PdfDrawElement] {

		switch pair.style {
			case .standard:
				return standardRowElements(pair, yPosition: yPosition)
			case .download:
				return [downloadRowElement(pair, yPosition: yPosition)]
		}
	}

	// MARK: - Row style helpers

	private func standardRowElements(
		_ pair: PdfSubTablePair,
		yPosition: CGFloat
	) -> [PdfDrawElement] {

		let keyText = attributed(
			pair.key,
			font: .helvetica(10),
			color: theme.secondaryText
		)
		let valueText = attributed(
			pair.value,
			font: .helvetica(10),
			color: theme.primaryText
		)
		let textHeight = max(
			keyText.height(in: halfWidthBoundingSize),
			valueText.height(in: halfWidthBoundingSize)
		)
		let halfWidth = PdfExport.Constants.contentSize.width / 2
		return [
			PdfDrawElement(
				text: keyText,
				borderColor: theme.border,
				rect: CGRect(
					x: PdfExport.Constants.outerMargin,
					y: yPosition,
					width: halfWidth,
					height: textHeight
				),
				height: textHeight + 8
			),
			PdfDrawElement(
				text: valueText,
				borderColor: theme.border,
				rect: CGRect(
					x: PdfExport.Constants.outerMargin + halfWidth,
					y: yPosition,
					width: halfWidth,
					height: textHeight
				),
				height: textHeight + 8
			)
		]
	}

	private func downloadRowElement(
		_ pair: PdfSubTablePair,
		yPosition: CGFloat
	) -> PdfDrawElement {

		let fontSize: CGFloat = 10
		let text = NSMutableAttributedString()

		let iconSize = CGSize(width: fontSize, height: fontSize)
		let config = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .regular)
		if let symbolImage = UIImage(systemName: "paperclip", withConfiguration: config)?
			.withTintColor(UIColor(theme.linkText), renderingMode: .alwaysOriginal) {
			let rasterized = UIGraphicsImageRenderer(size: iconSize).image { _ in
				symbolImage.draw(in: CGRect(origin: .zero, size: iconSize))
			}
			let attachment = NSTextAttachment(image: rasterized)
			attachment.bounds = CGRect(x: 0, y: -1, width: fontSize, height: fontSize)
			text.append(NSAttributedString(attachment: attachment))
			text.append(NSAttributedString(string: " "))
		}
		
		text.append(
			attributed(
				pair.value,
				font: .helvetica(fontSize),
				color: theme.linkText
			)
		)

		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: theme.border,
			yPosition: yPosition,
			textHeight: textHeight,
			heightOffset: 8
		)
	}

	/// Get the PDF draw element for the footer
	/// - Parameter pdfData: the pdf data
	/// - Returns: footer PDF draw element
	public func createFooterElement(_ pdfData: PdfData) -> PdfDrawElement {
		
		let text = attributed(
			pdfData.footer,
			font: .helvetica(10),
			color: theme.secondaryText
		)
		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: nil,
			yPosition: PdfExport.Constants.contentSize.height - textHeight,
			textHeight: textHeight
		)
	}

	/// Create a PDF draw element for pagination
	/// - Parameters:
	///   - pagination: pagination text
	/// - Returns: pdf draw element for the pagination
	public func createPaginationElement(_ pagination: String) -> PdfDrawElement {
		
		let text = attributed(
			pagination,
			font: .helvetica(10),
			color: theme.secondaryText
		)
		let textBox = text.measure(in: boundingSize)
		return PdfDrawElement(
			text: text,
			borderColor: nil,
			rect: CGRect(
				x: PdfExport.Constants.outerMargin + PdfExport.Constants.contentSize.width - textBox.width,
				y: PdfExport.Constants.contentSize.height - textBox.height,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}

	/// Create a PDF draw element for an empty sub category
	/// - Parameters:
	///   - content: the  content to draw (String)
	///   - yPosition: the  y-position to draw from
	/// - Returns: pdf draw element for an empty sub category
	public func createEmptySubCategoryDrawElement(
		_ content: String,
		yPosition: CGFloat
	) -> PdfDrawElement {
		
		let text = attributed(
			content, font: .helvetica(10),
			color: theme.primaryText
		)
		let textHeight = text.height(in: boundingSize)
		return fullWidthElement(
			text: text,
			borderColor: theme.border,
			yPosition: yPosition,
			textHeight: textHeight
		)
	}

	// MARK: - Private Helpers

	/// Build an attributed string with font and foreground color
	private func attributed(
		_ string: String,
		font: UIFont?,
		color: Color
	) -> NSAttributedString {
		
		NSAttributedString(
			string: string,
			attributes: [
				.font: font as Any,
					.foregroundColor: UIColor(color)
			]
		)
	}

	/// Build a full-width draw element at the outer margin
	private func fullWidthElement(
		text: NSAttributedString,
		borderColor: Color?,
		yPosition: CGFloat,
		textHeight: CGFloat,
		heightOffset: CGFloat = 0
	) -> PdfDrawElement {
		PdfDrawElement(
			text: text,
			borderColor: borderColor,
			rect: CGRect(
				x: PdfExport.Constants.outerMargin,
				y: yPosition,
				width: PdfExport.Constants.contentSize.width,
				height: textHeight
			),
			height: textHeight + heightOffset
		)
	}
}

private extension NSAttributedString {

	/// The height of the text bounded by the given size
	func height(in size: CGSize) -> CGFloat {
		measure(in: size).height
	}

	/// The bounding rect of the text bounded by the given size
	func measure(in size: CGSize) -> CGRect {
		boundingRect(
			with: size,
			options: .usesLineFragmentOrigin,
			context: nil
		)
	}
}
