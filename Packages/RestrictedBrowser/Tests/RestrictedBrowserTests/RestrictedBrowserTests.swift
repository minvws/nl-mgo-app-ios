/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser

final class RestrictedBrowserTests: XCTestCase {
	
	func test_isDomainAllowed_allowed() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"])
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == true
	}

	func test_isDomainAllowed_notAllowed() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["google.com"])
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == false
	}

	func test_isDomainAllowed_notAllowedSubDomain() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"])
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		expect(result) == false
	}
	
	func test_handleUnallowedDomain() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		sut.handleUnallowedDomain(url)
		
		// Then
		expect(urlOpenerSpy.invokedCanOpenURL) == true
		expect(urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
	
	func test_openInDefaultBrowser() throws {
		
		// Given
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try XCTUnwrap(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(allowedDomains: ["apple.com"], urlOpener: urlOpenerSpy)
		
		// When
		sut.openInDefaultBrowser(url: url)
		
		// Then
		expect(urlOpenerSpy.invokedCanOpenURL) == true
		expect(urlOpenerSpy.invokedOpen).toEventually(beTrue())
	}
}
