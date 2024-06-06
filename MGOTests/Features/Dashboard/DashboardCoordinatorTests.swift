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

final class DashboardCoordinatorTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinator)
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_searchHealthcareProviders_pathForSheet_shouldBeSet() {

		// Given
		
		// When
		sut.handle(Coordination.Action.searchHealthcareProviders)

		// Then
		expect(self.sut.rootStateForSheet) == DashboardCoordination.State.searchHealthcareProvider
	}

	func test_coordinatorHandle_search_pathForSheet_shouldContainSearchHealthcareProviders() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "search", params: ["city": "Roermond", "name": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.searchHealthcareProviders(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}

	func test_coordinatorHandle_search_missingParams_pathForSheet_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "search", params: ["city": "Roermond", "wrong param": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_storeHealthcareProvider_pathForSheet_shouldBeSet() {

		// Given
		
		// When
		sut.handle(Coordination.Action.storeHealthcareProvider)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.storedHealthcareProviders])
	}
	
	func test_coordinatorHandle_backToSearchHealthcareProvider_pathForSheet_shouldBeEmpty() {

		// Given
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.storedHealthcareProviders])
		
		// When
		sut.handle(Coordination.Action.backToSearchHealthcareProvider)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}

	func test_coordinatorHandle_finishedSearchingHealthcareProviders_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = DashboardCoordination.State.searchHealthcareProvider
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.storedHealthcareProviders])
		
		// When
		sut.handle(Coordination.Action.finishedSearchingHealthcareProviders)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}

	func test_coordinatorHandle_closeSheet_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = DashboardCoordination.State.searchHealthcareProvider
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.storedHealthcareProviders])
		
		// When
		sut.handle(Coordination.Action.closeSheet)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetNotEmpty_shouldBeReduced() {

		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.pathForSheet = NavigationStackBackport.NavigationPath(
			[DashboardCoordination.State.searchHealthcareProvider,
			 DashboardCoordination.State.storedHealthcareProviders]
		)
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.searchHealthcareProvider])
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetEmpty_firstPath_shouldBeReduced() {

		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.pathForSheet = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet.isEmpty) == true
		expect(self.sut.firstTabPath.isEmpty) == true
	}

	func test_coordinatorHandle_resetApplication_shouldCallParentCoordinator() {

		// Given
		
		// When
		sut.handle(Coordination.Action.resetApplication)

		// Then
		expect(self.parentCoordinator.invokedHandle).toEventually(beTrue())
		expect(self.parentCoordinator.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
	
	func test_coordinatorHandle_showHealthcareProviderDetails_firstTabPath_shouldContainSearchHealthcareProviders() {

		// Given
		let provider = Generator.healthcareProvider("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareProviderDetails", params: ["healthcareProvider": provider]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.showHealthcareProviderDetails(healthcareProvider: provider)])
	}

	func test_coordinatorHandle_showHealthcareProviderDetails_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareProviderDetails", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showHealthcareProviderDetails_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareProviderDetails", params: ["showHealthcareProviderDetails": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showProblems_firstTabPath_shouldContainSearchHealthcareProviders() {

		// Given
		let provider = Generator.healthcareProvider("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showProblems", params: ["healthcareProvider": provider]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.showProblems(healthcareProvider: provider)])
	}

	func test_coordinatorHandle_showProblems_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showProblems", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showProblems_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showProblems", params: ["showHealthcareProviderDetails": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showMedication_firstTabPath_shouldContainSearchHealthcareProviders() {

		// Given
		let provider = Generator.healthcareProvider("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: ["healthcareProvider": provider]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.showMedication(healthcareProvider: provider)])
	}

	func test_coordinatorHandle_showMedication_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showMedication_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: ["showHealthcareProviderDetails": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showResults_firstTabPath_shouldContainSearchHealthcareProviders() {

		// Given
		let provider = Generator.healthcareProvider("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showLabResults", params: ["healthcareProvider": provider]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.showLabResults(healthcareProvider: provider)])
	}

	func test_coordinatorHandle_showResults_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showLabResults", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showResults_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showLabResults", params: ["showHealthcareProviderDetails": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
}
