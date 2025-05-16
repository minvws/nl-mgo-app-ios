/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthDownloadViewTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthDataDownloadViewModel!
	private var sut: HealthDataDownloadView!
	private var binaryRepositorySpy: BinaryRepositorySpy!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		
		servicesSpies = setupServicesSpies()
		binaryRepositorySpy = BinaryRepositorySpy()
		let entry = DownloadLink(label: "label", type: DownloadLinkType.downloadLink, url: "Binary/demo1")
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataDownloadViewModel(healthcareOrganization: healthcareOrganization, downloadLink: entry)
		sut = HealthDataDownloadView(viewModel: self.viewModel)
	}
	
	func test_HealthDownloadView_idle() {
		
		// Given
		viewModel.state = .idle(label: "Test download")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthDownloadView_downloaded() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .downloaded(label: "Test download", documentUrl: url)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthDownloadView_downloaded_txt() throws {
		
		// Given
		let bundle = Bundle(for: type(of: self))
		let resourceUrl = try XCTUnwrap(bundle.url(forResource: "test", withExtension: "txt"))
		viewModel.state = .downloaded(label: "Test download", documentUrl: resourceUrl)
		viewModel.showPreview = true
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthDownloadView_external() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .external(label: "Test download", documentUrl: url)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthDownloadView_loading() throws {
		
		// Given
		viewModel.state = .loading(label: "label")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_HealthDownloadView_error() throws {
		
		// Given
		viewModel.state = .error
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	func test_HealthDownloadView_error_tryAgain() throws {
		
		// Given
		let entry = DownloadBinary(label: "label", reference: "Binary/demo1", type: DownloadBinaryType.downloadBinary)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataDownloadViewModel(healthcareOrganization: healthcareOrganization, downloadBinary: entry, binaryRepository: binaryRepositorySpy)
		sut = HealthDataDownloadView(viewModel: self.viewModel)
		
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		binaryRepositorySpy.stubbedStoreResult = url
		viewModel.state = .error
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "feedbackAction").button().tap()
		
		// Then
		expect(self.viewModel.state).toEventually(equal(.downloaded(label: "label", documentUrl: url)))
	}
	
	func test_HealthDownloadView_noDocument() throws {
		
		// Given
		viewModel.state = .noDocument
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
