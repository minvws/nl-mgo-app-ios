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
}
