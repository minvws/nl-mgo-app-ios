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
	}
	
	@MainActor private func createSut(forIpad: Bool = false) {
		
		viewModel = HealthExportViewModel(
			coordinator: coordinatorSpy,
			healthData: HealthExportViewModelTests.pdfData,
			forIpad: forIpad
		)
		sut = HealthExportView(viewModel: self.viewModel)
	}
	
	@MainActor func test_exportView() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_iPad() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut(forIpad: true)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
