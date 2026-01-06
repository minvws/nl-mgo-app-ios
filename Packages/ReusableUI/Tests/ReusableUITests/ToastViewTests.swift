/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class ToastViewTests: XCTestCase {
	
	func test_toast_info() {
		
		// Given
		let sut = ToastView(
			Feedback(
				title: "Test Banner",
				subtitle: "Type Info",
				type: .info
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_toast_info_longerTexts() {
		
		// Given
		let sut = ToastView(
			Feedback(
				title: "Test Banner Test Banner Test Banner Test Banner",
				subtitle: "Type Info Type Info Type Info",
				type: .info
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_toast_warning() {
		
		// Given
		let sut = ToastView(
			Feedback(
				title: "Test Banner",
				subtitle: "Type Warning",
				type: .warning
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_toast_error() {
		
		// Given
		let sut = ToastView(
			Feedback(
				title: "Test Banner",
				subtitle: "Type Error",
				type: .error
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	func test_toast_success() {
		
		// Given
		let sut = ToastView(
			Feedback(
				title: "Test Banner",
				subtitle: "Type Success",
				type: .success
			)
		)
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.light)),
			as: .image
		)
		assertSnapshot(
			of: UIHostingController(rootView: view.colorScheme(.dark)),
			as: .image
		)
	}
	
	@MainActor
	func test_toast_close() async throws {
		
		// Given
		var closedTapped = false
		var actionTapped = false
		let sut = ToastView(
			Feedback(
				title: "Close Banner",
				subtitle: "Type Success",
				type: .success,
				perform: {
					actionTapped = true
				}
			),
			closeAction: {
				closedTapped = true
			}
		)
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "toast.close").button().tap()
		
		// Then
		await expect(closedTapped).toEventually(beTrue())
		await expect(actionTapped).toEventually(beFalse())
	}
	
	@MainActor
	func test_toast_action() async throws {
		
		// Given
		var closedTapped = false
		var actionTapped = false
		let sut = ToastView(
			Feedback(
				title: "Close Banner",
				subtitle: "Type Success",
				type: .success,
				perform: {
					actionTapped = true
				}
			),
			closeAction: {
				closedTapped = true
			}
		)
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "toast.subheading").button().tap()
		
		// Then
		await expect(closedTapped).toEventually(beFalse())
		await expect(actionTapped).toEventually(beTrue())
	}
}
