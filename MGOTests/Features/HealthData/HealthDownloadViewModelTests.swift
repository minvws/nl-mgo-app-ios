/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import RestrictedBrowser

@MainActor
@Suite(.serialized)
struct HealthDownloadViewModelTests {
	
	private let servicesSpies: ServicesSpies
	private let urlOpenerSpy: URLOpenerSpy
	private let fileStorageSpy: FileStorageSpy
	
	init() {
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		fileStorageSpy = FileStorageSpy()
	}
	
	/// Create a HealthDataDownloadViewModel with a download link
	/// - Parameter url: the link for the download link
	private func makeSut(url: String?) -> HealthDataDownloadViewModel {
		
		let entry = DownloadLink(
			id: "HealthDownloadViewModelTests",
			label: "label",
			type: DownloadLinkType.downloadLink,
			url: url
		)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		return HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadLink: entry,
			urlOpener: urlOpenerSpy
		)
	}
	
	/// Create a HealthDataDownloadViewModel with a download binary
	/// - Parameter reference: the reference for the download binary
	private func makeSut(reference: String) -> HealthDataDownloadViewModel {
		
		let entry = DownloadBinary(
			id: "HealthDownloadViewModelTests",
			label: "label",
			reference: reference,
			type: DownloadBinaryType.downloadBinary
		)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		return HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadBinary: entry,
			storage: fileStorageSpy
		)
	}
	
	/// Drives the cooperative executor until the view model reaches `expected`,
	/// standing in for Nimble's `toEventually` polling on the async download paths.
	private func awaitState(
		_ expected: HealthDataDownloadState,
		of sut: HealthDataDownloadViewModel
	) async {
		for _ in 0..<100 where sut.state != expected {
			await Task.yield()
		}
	}
	
	@Test("A download link with a URL initializes to idle")
	func init_stateShouldBeIdle() {
		
		// Given
		let sut = makeSut(url: "Binary/demo1")
		
		// When
		
		// Then
		#expect(sut.state == .idle(label: "label"))
	}
	
	@Test("A download link without a URL initializes to no-document")
	func init_withoutURL_stateShouldBeNoDocument() {
		
		// Given
		let sut = makeSut(url: nil)
		
		// When
		
		// Then
		#expect(sut.state == .noDocument)
	}
	
	@Test("Downloading a link with no URL yields no document")
	func reduce_download_noUrl() {
		
		// Given
		let sut = makeSut(url: nil)
		
		// When
		sut.reduce(.download)
		
		// Then
		#expect(sut.state == .noDocument)
	}
	
	@Test("Downloading an https link opens it externally")
	func reduce_download_hyperlink() throws {
		
		// Given
		let url = try #require(URL(string: "https://example.com"))
		let sut = makeSut(url: "https://example.com")
		
		// When
		sut.reduce(.download)
		
		// Then
		#expect(sut.state == .external(label: "label", documentUrl: url))
		#expect(urlOpenerSpy.invokedCanOpenURL)
		#expect(urlOpenerSpy.invokedCanOpenURLParameters?.url == url)
	}
	
	@Test("Downloading a link with a non-hyperlink URL opens nothing and yields no document")
	func reduce_download_other() {
		
		// Given
		let sut = makeSut(url: "other")
		
		// When
		sut.reduce(.download)
		
		// Then
		#expect(urlOpenerSpy.invokedCanOpenURL == false)
		#expect(sut.state == .noDocument)
	}
	
	@Test("Downloading a binary with no content yields an error")
	func reduce_download_binary_noContent() async {
		
		// Given
		let sut = makeSut(reference: "reduce_download_binary_noContent")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = nil
		
		// When
		sut.reduce(.download)
		await awaitState(.error, of: sut)
		
		// Then
		#expect(sut.state == .error)
	}
	
	@Test("A failing binary load yields an error")
	func reduce_download_binary_error() async {
		
		// Given
		let sut = makeSut(reference: "reduce_download_binary_error")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinaryError = NSError(domain: "reduce_download_binary_error", code: 404)
		
		// When
		sut.reduce(.download)
		await awaitState(.error, of: sut)
		
		// Then
		#expect(sut.state == .error)
	}
	
	@Test("Downloading a link whose URL is a bare reference yields no document")
	func reduce_download_noReference() async throws {
		
		// Given
		let sut = makeSut(url: "Binary/demo1")
		let binary = FHIRBinary(
			contentType: "application/pdf",
			content: "Um9vbA=="
		)
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		let url = try #require(URL(string: "https://example.com"))
		fileStorageSpy.stubbedFileUrlResult = url
		
		// When
		sut.reduce(.download)
		await awaitState(.noDocument, of: sut)
		
		// Then
		#expect(sut.state == .noDocument)
	}
	
	@Test("Downloading a binary stores the file and transitions to downloaded")
	func reduce_download_binary() async throws {
		
		// Given
		let sut = makeSut(reference: "reduce_download_binary")
		let binary = FHIRBinary(
			contentType: "application/pdf",
			content: "Um9vbA=="
		)
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		let url = try #require(URL(string: "https://example.com"))
		fileStorageSpy.stubbedFileUrlResult = url
		
		// When
		sut.reduce(.download)
		await awaitState(.downloaded(label: "label", documentUrl: url), of: sut)
		
		// Then
		#expect(sut.state == .downloaded(label: "label", documentUrl: url))
	}
	
	@Test("Downloading a binary with no storage directory yields an error")
	func reduce_download_noDirectory() async {
		
		// Given
		let sut = makeSut(reference: "reduce_download_binary")
		let binary = FHIRBinary(
			contentType: "application/pdf",
			content: "Um9vbA=="
		)
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		fileStorageSpy.stubbedFileUrlResult = nil
		
		// When
		sut.reduce(.download)
		await awaitState(.error, of: sut)
		
		// Then
		#expect(sut.state == .error)
	}
}
