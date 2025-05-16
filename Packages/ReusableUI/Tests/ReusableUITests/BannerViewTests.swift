/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class BannerViewTests: XCTestCase {
	
	func test_banner_info() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Info", type: .info))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_info_withActionTitle() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Info", actionTitle: "Tap me!", type: .info))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_warning() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Warning", type: .warning))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_warning_withActionTitle() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Warning", actionTitle: "Tap me!", type: .warning))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_error() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Error", type: .error))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_error_withActionTitle() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Error", actionTitle: "Tap me!", type: .error))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_success() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Success", type: .success))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
	
	func test_banner_success_withActionTitle() throws {
		
		// Given
		let sut = BannerView(Feedback(title: "Test Banner", subtitle: "Type Success", actionTitle: "Tap me!", type: .success))
		
		// When
		let view = sut.frame(width: 300, height: 200)
		
		// Then
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.light)), as: .image)
		assertSnapshot(of: UIHostingController(rootView: view.colorScheme(.dark)), as: .image)
	}
}
