/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Which sides of a bordered element to draw
public struct BorderSides: OptionSet, Sendable {
	
	public let rawValue: Int
	
	public init(rawValue: Int) { self.rawValue = rawValue }
	
	public static let top    = BorderSides(rawValue: 1 << 0)
	
	public static let bottom = BorderSides(rawValue: 1 << 1)
	
	public static let left   = BorderSides(rawValue: 1 << 2)
	
	public static let right  = BorderSides(rawValue: 1 << 3)
	
	public static let all: BorderSides = [.top, .bottom, .left, .right]
}

@MainActor public struct PdfDrawElement {

	/// The text to draw
	public let text: NSAttributedString?

	/// The optional border color
	public let borderColor: Color?

	/// Which sides of the border to draw
	public var borderSides: BorderSides

	/// The rect to draw in.
	public var rect: CGRect

	/// The height this element uses
	public let height: CGFloat

	/// Is this a page break
	public let isPageBreak: Bool

	/// Create a PDF Draw Element
	/// - Parameters:
	///   - text: the text to draw
	///   - borderColor: the optional border color
	///   - borderSides: which sides of the border to draw
	///   - rect: the rect to draw in.
	///   - height: the height this element uses
	///   - isPageBreak: is this a page break
	public init(
		text: NSAttributedString?,
		borderColor: Color? = nil,
		borderSides: BorderSides = .all,
		rect: CGRect,
		height: CGFloat,
		isPageBreak: Bool = false
	) {
		self.text = text
		self.borderColor = borderColor
		self.borderSides = borderSides
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
			static let verticalPadding: CGFloat = 6
			static let horizontalPadding: CGFloat = 12
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

		let topPadding: CGFloat = borderSides.contains(.top) ? DrawTraits.General.horizontalPadding : DrawTraits.General.verticalPadding
		let bottomPadding: CGFloat = borderSides.contains(.bottom) ? DrawTraits.General.horizontalPadding : DrawTraits.General.verticalPadding
		inset = topPadding
		context.cgContext.setLineWidth(DrawTraits.Border.width)
		context.cgContext.setStrokeColor(UIColor(borderColor).cgColor)

		let borderRect = CGRect(
			x: rect.origin.x,
			y: rect.origin.y,
			width: rect.width,
			height: rect.height + topPadding + bottomPadding
		)

		context.cgContext.beginPath()
		if borderSides.contains(.top) {
			context.cgContext.move(to: CGPoint(x: borderRect.minX, y: borderRect.minY))
			context.cgContext.addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.minY))
		}
		if borderSides.contains(.bottom) {
			context.cgContext.move(to: CGPoint(x: borderRect.minX, y: borderRect.maxY))
			context.cgContext.addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.maxY))
		}
		if borderSides.contains(.left) {
			context.cgContext.move(to: CGPoint(x: borderRect.minX, y: borderRect.minY))
			context.cgContext.addLine(to: CGPoint(x: borderRect.minX, y: borderRect.maxY))
		}
		if borderSides.contains(.right) {
			context.cgContext.move(to: CGPoint(x: borderRect.maxX, y: borderRect.minY))
			context.cgContext.addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.maxY))
		}
		context.cgContext.strokePath()
	}
	
	/// Draw the text
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - inset: the inset to use
	@MainActor private func drawText(inset: CGFloat) {
		
		guard let text else { return }
		
		text.draw(
			in: CGRect(
				x: rect.origin.x + DrawTraits.General.horizontalPadding,
				y: rect.origin.y + inset,
				width: rect.width - 2 * DrawTraits.General.horizontalPadding,
				height: rect.height
			)
		)
	}
}
