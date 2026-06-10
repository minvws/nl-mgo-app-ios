/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/**
 * A Text view where the text is selectable.
 *
 * Wraps a UITextView so the user can select and copy individual words.
 * Height is managed via a @State property that UIKit updates once it knows the
 * available width, sidestepping the chicken-and-egg problem where SwiftUI's
 * layout pass runs before UIKit has assigned a real frame to the inner view.
 */
public struct SelectableTextView: View {

	let text: String
	let textColor: Color
	let font: UIFont?

	@State private var height: CGFloat = 20

	public init(text: String, textColor: Color, font: UIFont?) {
		self.text = text
		self.textColor = textColor
		self.font = font
	}

	public var body: some View {
		_SelectableUITextView(
			text: text,
			textColor: textColor,
			font: font
		) { newHeight in
			guard abs(height - newHeight) > 0.5 else { return }
			height = newHeight
		}
		.frame(height: height)
	}
}

// MARK: - UIViewRepresentable

private struct _SelectableUITextView: UIViewRepresentable {

	let text: String
	let textColor: Color
	let font: UIFont?
	let onHeightChange: (CGFloat) -> Void

	func makeUIView(context: Context) -> AutoSizingTextView {
		let textView = AutoSizingTextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.isScrollEnabled = false
		textView.backgroundColor = .clear
		textView.font = font ?? .preferredFont(forTextStyle: .body)
		textView.textColor = UIColor(textColor)
		textView.textContainer.lineFragmentPadding = 0
		textView.textContainerInset = .zero
		textView.text = text
		return textView
	}

	func updateUIView(_ textView: AutoSizingTextView, context: Context) {
		if textView.text != text {
			textView.text = text
			textView.setNeedsLayout()
		}
		textView.onHeightChange = onHeightChange
	}
}

// MARK: - AutoSizingTextView

/**
 * UITextView subclass that reports its height to a SwiftUI callback once UIKit
 * has assigned a real width.  Height is driven from outside via .frame(height:)
 * so intrinsicContentSize is intentionally not overridden.
 */
final class AutoSizingTextView: UITextView {

	var onHeightChange: ((CGFloat) -> Void)?

	// Returning noIntrinsicMetric for both dimensions lets SwiftUI size the
	// view purely from Auto Layout constraints (row width from the List).
	// Without this, UITextView reports a single-line width as its intrinsic
	// width and text never wraps.
	override var intrinsicContentSize: CGSize {
		CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let width = frame.size.width
		guard width > 0 else { return }
		let newHeight = sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
		guard newHeight > 0 else { return }
		DispatchQueue.main.async { [weak self] in
			self?.onHeightChange?(newHeight)
		}
	}

	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		action == #selector(copy(_:))
	}
}
