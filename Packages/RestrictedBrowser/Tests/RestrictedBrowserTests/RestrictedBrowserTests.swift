/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser

final class RestrictedBrowserTests: XCTestCase {
	
	private var urlOpenerSpy: URLOpenerSpy!
	
	override func setUp() {
		super.setUp()
		urlOpenerSpy = URLOpenerSpy()
	}
	
	@MainActor func test_isDomainAllowed_allowed() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == true
	}

	@MainActor func test_isDomainAllowed_notAllowed() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["google.com"], urlOpener: urlOpenerSpy)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == false
	}

	@MainActor func test_isDomainAllowed_notAllowedSubDomain() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == false
	}
	
	@MainActor func test_handleUnallowedDomain() throws {
		
		// Given
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		sut.handleUnallowedDomain(url)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == true
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	@MainActor func test_openInDefaultBrowser() throws {
		
		// Given
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		sut.openInDefaultBrowser(url: url)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == true
		expect(self.urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
}
