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
	
	@MainActor private func createSut(forIpad: Bool = false) async {
		
		viewModel = HealthExportViewModel(
			coordinator: coordinatorSpy,
			healthData: HealthExportViewModelTests.pdfData,
			forIpad: forIpad
		)
		await viewModel.generatePDF()
		sut = HealthExportView(viewModel: self.viewModel)
	}
	
	@MainActor func test_exportView() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		await createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_asSheet() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		await createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, true)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_iPad() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		await createSut(forIpad: true)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_iOS18() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		await createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_iPad_iOS18() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		await createSut(forIpad: true)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_exportView_withLastGroupExcluded() async {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let block = Generator.healthCategoryBlockWithLastGroupExcluded()
		let pdfData = HealthDataMapper().map("Medicijnen", blocks: [block])
		viewModel = HealthExportViewModel(coordinator: coordinatorSpy, healthData: pdfData)
		await viewModel.generatePDF()
		sut = HealthExportView(viewModel: self.viewModel)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
			.environment(\.isPresentedAsSheet, false)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
