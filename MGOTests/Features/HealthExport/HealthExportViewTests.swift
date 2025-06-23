/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

final class HealthExportViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthExportViewModel!
	private var sut: HealthExportView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		viewModel = HealthExportViewModel(
			coordinator: coordinatorSpy,
			healthData: HealthExportViewModelTests.pdfData
		)
		sut = HealthExportView(viewModel: self.viewModel)
	}
	
	func test_exportView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
