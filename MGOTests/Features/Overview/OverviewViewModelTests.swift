/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OverviewViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OverviewViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		var sendUpdate: ((Bool) -> Void)?
		(servicesSpies.healthcareProviderStoreSpy.stubbedObservatory, sendUpdate) = Observatory<Bool>.create()
		
		sut = OverviewViewModel(coordinator: coordinatorSpy)
	}

	func test_onAppear_shouldCallStore_noProviders_stateShouldBeEmtpy() {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetter) == true
		expect(self.sut.state) == .empty
	}
	
	func test_onAppear_shouldCallStore_withProviders_stateShouldBeList() {
		
		// Given
		let provider = Generator.healthcareProvider("1")
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = [provider]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetter) == true
		expect(self.sut.state) == .list([provider])
	}
	
	func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.searchHealthcareProviders
	}
}
