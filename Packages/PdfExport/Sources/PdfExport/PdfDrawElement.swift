/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

@MainActor public struct PdfDrawElement {
	
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
		isPageBreak: Bool = false
	) {
		self.text = text
		self.backgroundColor = backgroundColor
		self.borderColor = borderColor
		self.rect = rect
		self.height = height
		self.isPageBreak = isPageBreak
	}
	
	/// A page break element
	static public let pageBreak: PdfDrawElement = .init(
		text: nil,
		rect: .zero,
		height: 0,
		isPageBreak: true
	)
}

extension PdfDrawElement {
	
	/// Magic Numbers
	private struct DrawTraits {
		enum General {
			static let padding: CGFloat = 6
		}
		enum Background {
			static let inset: CGFloat = 1
		}
		enum Border {
			static let width: CGFloat = 1
		}
	}
	
	/// Draw this pdf draw element
	/// - Parameter context: The drawing environment for a PDF renderer.
	@MainActor public func draw(_ context: UIGraphicsPDFRendererContext) {
		
		var inset: CGFloat = 0
		
		drawBorder(context, inset: &inset)
		drawBackground(context, inset: &inset)
		drawText(inset: inset)
	}
	
	/// Draw the border
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - inset: the inset as a result
	@MainActor private func drawBorder(
		_ context: UIGraphicsPDFRendererContext,
		inset: inout CGFloat
	) {
		
		guard let borderColor else { return }
		
		inset = DrawTraits.General.padding
		context.cgContext.setLineWidth(DrawTraits.Border.width)
		context.cgContext.setStrokeColor(UIColor(borderColor).cgColor)
		context.stroke(
			CGRect(
				x: rect.origin.x,
				y: rect.origin.y,
				width: rect.width,
				height: rect.height + (2 * DrawTraits.General.padding)
			)
		)
	}
	
	/// Draw the background
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - inset: the inset as a result
	@MainActor private func drawBackground(
		_ context: UIGraphicsPDFRendererContext,
		inset: inout CGFloat
	) {
		
		guard let backgroundColor else { return }
		
		inset = DrawTraits.General.padding
		context.cgContext.setFillColor(UIColor(backgroundColor).cgColor)
		context.fill(
			CGRect(
				x: rect.origin.x + DrawTraits.Background.inset,
				y: rect.origin.y + DrawTraits.Background.inset,
				width: rect.width - (2 * DrawTraits.Background.inset),
				height: rect.height + (2 * (DrawTraits.General.padding - DrawTraits.Background.inset))
			)
		)
	}
	
	/// Draw the text
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - inset: the inset to use
	@MainActor private func drawText(inset: CGFloat) {
		
		guard let text else { return }
		
		text.draw(
			in: CGRect(
				x: rect.origin.x + inset,
				y: rect.origin.y + inset,
				width: rect.width - 2 * inset,
				height: rect.height
			)
		)
	}
}
