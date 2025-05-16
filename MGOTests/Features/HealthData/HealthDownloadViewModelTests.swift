/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthDownloadViewModelTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	private var sut: HealthDataDownloadViewModel!
	private var urlOpenerSpy: URLOpenerSpy!
	private var binaryRepositorySpy: BinaryRepositorySpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		binaryRepositorySpy = BinaryRepositorySpy()
		createSut(url: "Binary/demo1")
	}
	
	/// Create a HealthDataDownloadViewModel with a download link
	/// - Parameter url: the link for the download link
	private func createSut(url: String?) {
		
		let entry = DownloadLink(label: "label", type: DownloadLinkType.downloadLink, url: url)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		sut = HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadLink: entry,
			urlOpener: urlOpenerSpy
		)
	}
	
	/// Create a HealthDataDownloadViewModel with a download binary
	/// - Parameter reference: the reference for the download binary
	private func createSut(reference: String) {
		
		let entry = DownloadBinary(label: "label", reference: reference, type: DownloadBinaryType.downloadBinary)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		sut = HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadBinary: entry,
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
		createSut(reference: "test_reduce_download_binary_noContent")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = nil
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state).toEventually(equal(.error))
	}
	
	func test_reduce_download_binary_error() throws {
		
		// Given
		createSut(reference: "test_reduce_download_binary_error")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinaryError = NSError(domain: "test_reduce_download_binary_error", code: 404)
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state).toEventually(equal(.error))
	}

	func test_reduce_download_noReference() throws {
		
		// Given
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		binaryRepositorySpy.stubbedStoreResult = url
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state).toEventually(equal(.noDocument))
	}
	
	func test_reduce_download_binary() throws {
		
		// Given
		createSut(reference: "test_reduce_download_binary")
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		binaryRepositorySpy.stubbedStoreResult = url
		
		// When
		sut.reduce(.download)
		
		// Then
		expect(self.sut.state).toEventually(equal(.downloaded(label: "label", documentUrl: url)))
	}
}
