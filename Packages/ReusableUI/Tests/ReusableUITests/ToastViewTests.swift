/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import XCTest
import SnapshotTesting

final class ToastViewTests: XCTestCase {

	func test_toast_info() throws {
		
		// Given
		let sut = ToastView(Toast(title: "Test Toast", subtitle: "Type Info", type: .info))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_toast_warning() throws {
		
		// Given
		let sut = ToastView(Toast(title: "Test Toast", subtitle: "Type Warning", type: .warning))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_toast_error() throws {
		
		// Given
		let sut = ToastView(Toast(title: "Test Toast", subtitle: "Type Error", type: .error))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_toast_success() throws {
		
		// Given
		let sut = ToastView(Toast(title: "Test Toast", subtitle: "Type Success", type: .success))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
}
