/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

public struct PdfDrawElement {
	
	/// The text to draw
	public let text: NSAttributedString?
	
	/// The optional background color
	public let backgroundColor: Color?
	
	/// The optional border color
	public let borderColor: Color?
	
	/// The rect to draw in.
	public var rect: CGRect
	
	/// The height this element uses
	public let height: CGFloat
	
	/// Is this a page break
	public let isPageBreak: Bool
	
	/// Create a PDF Draw Element
	/// - Parameters:
	///   - text: the text to draw
	///   - backgroundColor: the optional background color
	///   - borderColor: the optional border color
	///   - rect: the rect to draw in.
	///   - height: the height this element uses
	///   - isPageBreak: is this a page break
	public init(
		text: NSAttributedString?,
		backgroundColor: Color? = nil,
		borderColor: Color? = nil,
		rect: CGRect,
		height: CGFloat,
		isPageBreak: Bool = false) {
		self.text = text
		self.backgroundColor = backgroundColor
		self.borderColor = borderColor
		self.rect = rect
		self.height = height
		self.isPageBreak = isPageBreak
	}
	
	/// A page break element
	static let pageBreak: PdfDrawElement = .init(text: nil, rect: .zero, height: 0, isPageBreak: true)
	
	/// Draw this pdf draw element
	/// - Parameter context: The drawing environment for a PDF renderer.
	@MainActor func draw(_ context: UIGraphicsPDFRendererContext) {
		
		var inset: CGFloat = 0
		
		if let borderColor {
			inset = 6
			context.cgContext.setLineWidth(1)
			context.cgContext.setStrokeColor(UIColor(borderColor).cgColor)
			context.stroke(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height + 12))
		}
			
		if let backgroundColor {
			inset = 6
			context.cgContext.setFillColor(UIColor(backgroundColor).cgColor)
			context.fill(CGRect(x: rect.origin.x + 1, y: rect.origin.y + 1, width: rect.width - 2, height: rect.height + 10))
		}
		
		text?.draw(in: CGRect(x: rect.origin.x + inset, y: rect.origin.y + inset, width: rect.width - 2 * inset, height: rect.height))
	}
}
