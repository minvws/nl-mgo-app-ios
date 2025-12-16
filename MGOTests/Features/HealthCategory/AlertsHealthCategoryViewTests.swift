/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

class AlertsHealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoryView!
	private var categoryId: String!
	
	private let item = Generator.healthCategoryBlock()
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor func createSut(_ categoryId: String = "alerts") throws {

		self.categoryId = categoryId
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: categoryId))
		let translations = try XCTUnwrap(HealthCategoryViewTranslationsFactory.makeTranslations(for: category))
		
		viewModel = HealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: healthcareOrganization,
			translations: translations
		)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}
	
	@MainActor func test_stateLoading() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)", precision: 0.95)
	}
	
	@MainActor func test_stateEmptyListNoError() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [], errorState: .none)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateEmptyListLoadingState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [], errorState: .loading)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateEmptyListErrorState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(
			items: [],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		)
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListNoError() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [item], errorState: .none)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListLoadingState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [item], errorState: .loading)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListErrorState() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(
			items: [item],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		)
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListNoError_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [item], errorState: .none)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListLoadingState_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(items: [item], errorState: .loading)
		
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
	
	@MainActor func test_stateNotEmptyListErrorState_iOS26() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		try createSut()
		let content = NavigationView { sut }
		
		// When
		viewModel.state = .list(
			items: [item],
			errorState: .error(
				heading: "Error",
				subHeading: "Er is een fout opgetreden"
			)
		)
		// Then
		takeSnapShots(content: content, name: "\(categoryId)_\(#function)")
	}
}
