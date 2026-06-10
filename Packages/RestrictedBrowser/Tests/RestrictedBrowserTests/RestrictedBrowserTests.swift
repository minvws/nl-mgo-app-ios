/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
@testable import RestrictedBrowser

@Suite @MainActor
struct RestrictedBrowserTests {
	
	let urlOpenerSpy = URLOpenerSpy()
	
	@Test func test_isDomainAllowed_empty() throws {
		
		// Given
		let url = try #require(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: [],
			urlOpener: urlOpenerSpy
		)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		#expect(result == false)
	}
	
	@Test func test_isDomainAllowed_allowed() throws {
		
		// Given
		let url = try #require(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: ["apple.com"],
			urlOpener: urlOpenerSpy
		)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		#expect(result == true)
	}
	
	@Test func test_isDomainAllowed_notAllowed() throws {
		
		// Given
		let url = try #require(URL(string: "https://apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: ["google.com"],
			urlOpener: urlOpenerSpy
		)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		#expect(result == false)
	}
	
	@Test func test_isDomainAllowed_notAllowedSubDomain() throws {
		
		// Given
		let url = try #require(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: ["apple.com"],
			urlOpener: urlOpenerSpy
		)
		
		// When
		let result = sut.isDomainAllowed(url)
		
		// Then
		#expect(result == false)
	}
	
	@Test func test_handleUnallowedDomain() async throws {
		
		// Given
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try #require(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: ["apple.com"],
			urlOpener: urlOpenerSpy
		)
		
		// When
		sut.handleUnallowedDomain(url)
		
		// Then
		#expect(urlOpenerSpy.invokedCanOpenURL == true)
		await Task.yield()
		#expect(urlOpenerSpy.invokedOpen == true)
	}
	
	@Test func test_openInDefaultBrowser() async throws {
		
		// Given
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let url = try #require(URL(string: "https://support.apple.com"))
		let sut = RestrictedBrowser(
			allowedDomains: ["apple.com"],
			urlOpener: urlOpenerSpy
		)
		
		// When
		sut.openInDefaultBrowser(url: url)
		
		// Then
		#expect(urlOpenerSpy.invokedCanOpenURL == true)
		await Task.yield()
		#expect(urlOpenerSpy.invokedOpen == true)
	}
}
