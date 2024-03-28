/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import RestrictedBrowser
@testable import MGO

final class InAppBrowserViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: InAppBrowserViewModel!
	
	func setupSut() throws {
		
		coordinatorSpy = AppCoordinatorSpy()
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let browser = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		sut = InAppBrowserViewModel(url: url, browser: browser, title: nil, coordinator: coordinatorSpy)
	}
	
	func test_backButtonPressed() throws {
		
		// Given
		try setupSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backButtonPressed
	}
}
