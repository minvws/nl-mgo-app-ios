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

final class HealthCategoryDownloadViewTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryDownloadViewModel!
	private var sut: HealthCategoryDownloadView!
	
	override func setUpWithError() throws {

		try super.setUpWithError()

		let entry = UIEntry(display: nil, label: "label", summary: false, type: .downloadLink, reference: nil, url: "Binary/demo1")
		let healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = HealthCategoryDownloadViewModel(healthcareOrganization: healthcareOrganization, entry: entry)
		sut = HealthCategoryDownloadView(viewModel: self.viewModel)
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
