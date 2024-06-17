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

final class HealthcareProviderViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthcareProviderViewModel!
	private var healthcareProvider: HealthcareProvider!
	private var sut: HealthcareProviderView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareProvider = Generator.healthcareProvider("1")
		
		viewModel = HealthcareProviderViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider)
		sut = HealthcareProviderView(viewModel: self.viewModel)
	}
	
	func test_healthcareProvider_details() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
