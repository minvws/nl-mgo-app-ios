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

final class HealthDownloadViewTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthDataDownloadViewModel!
	private var sut: HealthDataDownloadView!
	
	override func setUpWithError() throws {

		try super.setUpWithError()

		servicesSpies = setupServicesSpies()
		let entry = UIElement(display: nil, label: "label", type: .downloadLink, reference: nil, url: "Binary/demo1")
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthDataDownloadViewModel(healthcareOrganization: healthcareOrganization, entry: entry)
		sut = HealthDataDownloadView(viewModel: self.viewModel)
	}
	
	func test_HealthCategoryDownloadView_idle() {
		
		// Given
		viewModel.state = .idle(label: "Test download")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthCategoryDownloadView_downloaded() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .downloaded(label: "Test download", documentUrl: url)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthCategoryDownloadView_external() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://apple.com"))
		viewModel.state = .external(label: "Test download", documentUrl: url)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthCategoryDownloadView_loading() throws {
		
		// Given
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_HealthCategoryDownloadView_error() throws {
		
		// Given
		viewModel.state = .error
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_HealthCategoryDownloadView_noDocument() throws {
		
		// Given
		viewModel.state = .noDocument
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
