/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI

/**
 * A Text view where the text is selectable
 */
struct SelectableTextView: UIViewRepresentable {
	
	/// The text to display
	let text: String
	
	/// The color of the text
	let textColor: Color
	
	/// The font to use
	let font: UIFont?
	
	/// UIViewRepresentable method to create a selectable text view
	/// - Parameter context: the context
	/// - Returns: selectable text view
	func makeUIView(context: UIViewRepresentableContext<SelectableTextView>) -> AutoSizingTextView {
		
		let textView = AutoSizingTextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.isScrollEnabled = false
		textView.backgroundColor = .clear
		if let font {
			textView.font = font
		} else {
			textView.font = .preferredFont(forTextStyle: .body)
		}
		textView.textColor = UIColor(textColor)
		textView.textContainer.lineFragmentPadding = 0
		textView.textContainerInset = .zero
		textView.text = text
		return textView
	}
	
	/// UIViewRepresentable method to update the view
	/// - Parameters:
	///   - textView: the selectable text view
	///   - context: the context
	func updateUIView(_ textView: AutoSizingTextView, context: UIViewRepresentableContext<SelectableTextView>) {
		textView.text = text
		textView.invalidateIntrinsicContentSize()
	}
}

/**
 * A subclassed UITextview that automatically adjust its size
 */
class AutoSizingTextView: UITextView {
	
	override var intrinsicContentSize: CGSize {
	
		let fixedWidth = frame.size.width
		let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		return CGSize(width: fixedWidth, height: newSize.height)
	}
	
	override func layoutSubviews() {
		
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
	}
	
	/// We should only allow the copy action.
	/// - Parameters:
	///   - action: the possible action
	///   - sender: the sender of the action
	/// - Returns: True if this is a copy action, false otherwise
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		switch action {
			case #selector(copy(_:)):
				return true
			default:
				return false
		}
	}
}
