/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	private var fileStorageSpy: FileStorageSpy!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		
		servicesSpies = setupServicesSpies()
		fileStorageSpy = FileStorageSpy()
	}
	
	@MainActor private func createSut() {
		
		let entry = DownloadLink(
			id: "HealthDownloadViewTests",
			label: "label",
			type: DownloadLinkType.downloadLink,
			url: "Binary/demo1"
		)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadLink: entry
		)
		sut = HealthDataDownloadView(viewModel: self.viewModel)
	}
	
	@MainActor func test_HealthDownloadView_idle() {
		
		// Given
		createSut()
		viewModel.state = .idle(label: "Test download")
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthDownloadView_downloaded() throws {
		
		// Given
		createSut()
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .downloaded(
			label: "Test download",
			documentUrl: url
		)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthDownloadView_downloaded_txt() throws {
		
		// Given
		createSut()
		let bundle = Bundle(for: type(of: self))
		let resourceUrl = try XCTUnwrap(bundle.url(forResource: "test", withExtension: "txt"))
		viewModel.state = .downloaded(
			label: "Test download",
			documentUrl: resourceUrl
		)
		viewModel.showPreview = true
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthDownloadView_external() throws {
		
		// Given
		createSut()
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .external(
			label: "Test download",
			documentUrl: url
		)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthDownloadView_loading() throws {
		
		// Given
		createSut()
		viewModel.state = .loading(label: "label")
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_HealthDownloadView_error() throws {
		
		// Given
		createSut()
		viewModel.state = .error
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	@MainActor func test_HealthDownloadView_error_tryAgain() throws {
		
		// Given
		let entry = DownloadBinary(
			id: "test_HealthDownloadView_error_tryAgain",
			label: "label",
			reference: "Binary/demo1",
			type: DownloadBinaryType.downloadBinary
		)
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataDownloadViewModel(
			healthcareOrganization: healthcareOrganization,
			downloadBinary: entry,
			storage: fileStorageSpy
		)
		sut = HealthDataDownloadView(viewModel: self.viewModel)
		
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		let binary = FHIRBinary(
			contentType: "application/pdf",
			content: "Um9vbA=="
		)
		servicesSpies.resourceRepositorySpy.stubbedLoadBinary = binary
		fileStorageSpy.stubbedFileUrlResult = url
		viewModel.state = .error
		
		// When
		try sut.inspect()
			.find(viewWithAccessibilityIdentifier: "feedbackAction")
			.button()
			.tap()
		
		// Then
		expect(self.viewModel.state).toEventually(
			equal(.downloaded(label: "label", documentUrl: url)),
			timeout: .seconds(10)
		)
	}
	
	@MainActor func test_HealthDownloadView_noDocument() throws {
		
		// Given
		createSut()
		viewModel.state = .noDocument
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
