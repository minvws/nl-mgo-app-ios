/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_allowedDomain_production() {
		
		// Given
		let release = Release.production
		
		// When
		let domains = Configuration().getAllowedDomains(for: release)
		
		// Then
		expect(domains).to(haveCount(1))
	}
	
	func test_allowedDomain_acceptance() {
		
		// Given
		let release = Release.acceptance
		
		// When
		let domains = Configuration().getAllowedDomains(for: release)
		
		// Then
		expect(domains).to(haveCount(2))
	}
	
	func test_allowedDomain_test() {
		
		// Given
		let release = Release.test
		
		// When
		let domains = Configuration().getAllowedDomains(for: release)
		
		// Then
		expect(domains).to(haveCount(1))
	}
	
	func test_allowedDomain_demo() {
		
		// Given
		let release = Release.demo
		
		// When
		let domains = Configuration().getAllowedDomains(for: release)
		
		// Then
		expect(domains).to(haveCount(1))
	}
	
	func test_allowedDomain_development() {
		
		// Given
		let release = Release.development
		
		// When
		let domains = Configuration().getAllowedDomains(for: release)
		
		// Then
		expect(domains).to(haveCount(3))
	}
}
