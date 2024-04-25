/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
@testable import RestrictedBrowser
import SnapshotTesting
import SwiftUI

final class RestrictedBrowserViewTests: XCTestCase {
	
	func test_restrictedBrowserView() throws {
	
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let viewModel = RestrictedBrowserViewModel(url: url, browser: browser)
		let sut = RestrictedBrowserView(viewModel: viewModel)
		
		// When
		let content = NavigationView { sut }.frame(width: 300, height: 800)
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image,
			named: "_darkPortrait"
		)
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image,
			named: "_lightPortrait"
		)
	}
}
