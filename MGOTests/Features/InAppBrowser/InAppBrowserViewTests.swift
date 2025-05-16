/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import RestrictedBrowser
import MGOUI
@testable import MGO

final class InAppBrowserViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var urlOpenerSpy: URLOpenerSpy!
	private var sut: InAppBrowserView!
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func setupSut(title: LocalizedStringKey = "") throws {
		
		coordinatorSpy = AppCoordinatorSpy()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://localhost/test"))
		let browser = RestrictedBrowser(allowedDomains: ["localhost"], urlOpener: urlOpenerSpy)
		let viewModel = InAppBrowserViewModel(url: url, browser: browser, title: title, coordinator: coordinatorSpy)
		sut = InAppBrowserView(viewModel: viewModel)
	}
	
	func test_backButtonPressed() throws {
		
		// Given
		try setupSut()
		
		// When
		try sut.inspect().find(viewWithTag: "close_view").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
