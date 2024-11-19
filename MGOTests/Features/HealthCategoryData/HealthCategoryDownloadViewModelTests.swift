/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import Zibs

final class HealthCategoryDownloadViewModelTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	private var sut: HealthCategoryDownloadViewModel!
	private var urlOpenerSpy: URLOpenerSpy!
	private var binaryRepositorySpy: BinaryRepositorySpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		binaryRepositorySpy = BinaryRepositorySpy()
		createSut(url: "Binary/demo1")
	}
	
	private func createSut(url: String?) {
		
		let entry = UIEntry(display: nil, label: "label", summary: false, type: .downloadLink, reference: nil, url: url)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		sut = HealthCategoryDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			entry: entry,
			urlOpener: urlOpenerSpy,
			binaryRepository: binaryRepositorySpy
		)
	}
	
	func test_init_stateShouldBeIdle() {
		
		// Given
		
		// When
		
		// Then
		expect(self.sut.state) == .idle(label: "label")
	}
	
	func test_init_withoutURL_stateShouldBeNoDocument() {
		
		// Given
		
		// When
		createSut(url: nil)
		
		// Then
		expect(self.sut.state) == .noDocument
	}
	
	func test_reduce_download_noUrl() {
		
		// Given
		createSut(url: nil)
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state) == .noDocument
	}
	
	func test_reduce_download_hyperlink() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		createSut(url: "https://example.com")
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state) == .external(label: "label", documentUrl: url)
		expect(self.urlOpenerSpy.invokedCanOpenURL) == true
		expect(self.urlOpenerSpy.invokedCanOpenURLParameters?.url) == url
	}
	
	func test_reduce_download_other() throws {
		
		// Given
		createSut(url: "other")
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == false
		expect(self.sut.state) == .noDocument
	}
	
	func test_reduce_download_binary_noContent() throws {
		
		// Given
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = nil
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == false
		expect(self.sut.state).toEventually(equal(.error))
	}
	
	func test_reduce_download_binary_error() throws {
		
		// Given
		servicesSpies.resourceRepositorySpy.stubbedLoadBinaryError = NSError(domain: "test_reduce_download_binary_error", code: 404)
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == false
		expect(self.sut.state).toEventually(equal(.error))
	}
	
	func test_reduce_download_binary() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let binary = Zibs.Binary(contentType: "application/pdf", content: "Um9vbA==")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		binaryRepositorySpy.stubbedStoreResult = url
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.urlOpenerSpy.invokedCanOpenURL) == false
		expect(self.sut.state).toEventually(equal(.downloaded(label: "label", documentUrl: url)))
	}
}
