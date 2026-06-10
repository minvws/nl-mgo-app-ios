/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

@MainActor
final class SelectableTextViewTests: XCTestCase {

	// MARK: - Snapshot tests

	func test_shortText() {

		// Given
		let sut = SelectableTextView(text: "Short text", textColor: .primary, font: nil)
			.padding()

		// Then
		takeSnapShots(content: sut)
	}

	func test_longText() {

		// Given
		let sut = SelectableTextView(
			text: "This is a much longer piece of text that should wrap across multiple lines when displayed at a typical phone screen width.",
			textColor: .primary,
			font: nil
		)
		.padding()

		// Then
		takeSnapShots(content: sut)
	}

	// MARK: - AutoSizingTextView: intrinsic size

	func test_intrinsicContentSize_width_isNoIntrinsicMetric() {

		// Given
		let sut = AutoSizingTextView()

		// When
		let size = sut.intrinsicContentSize

		// Then
		XCTAssertEqual(size.width, UIView.noIntrinsicMetric)
	}

	func test_intrinsicContentSize_height_isNoIntrinsicMetric() {

		// Given
		let sut = AutoSizingTextView()

		// When
		let size = sut.intrinsicContentSize

		// Then
		XCTAssertEqual(size.height, UIView.noIntrinsicMetric)
	}

	// MARK: - AutoSizingTextView: copy-only action gating

	func test_canPerformAction_copy_isAllowed() {

		// Given
		let sut = AutoSizingTextView()

		// Then
		XCTAssertTrue(sut.canPerformAction(#selector(UIResponder.copy(_:)), withSender: nil))
	}

	func test_canPerformAction_cut_isNotAllowed() {

		// Given
		let sut = AutoSizingTextView()

		// Then
		XCTAssertFalse(sut.canPerformAction(#selector(UIResponder.cut(_:)), withSender: nil))
	}

	func test_canPerformAction_paste_isNotAllowed() {

		// Given
		let sut = AutoSizingTextView()

		// Then
		XCTAssertFalse(sut.canPerformAction(#selector(UIResponder.paste(_:)), withSender: nil))
	}

	func test_canPerformAction_selectAll_isNotAllowed() {

		// Given
		let sut = AutoSizingTextView()

		// Then
		XCTAssertFalse(sut.canPerformAction(#selector(UIResponder.selectAll(_:)), withSender: nil))
	}
}
