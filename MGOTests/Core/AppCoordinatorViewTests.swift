/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO
import RestrictedBrowser

final class AppCoordinatorViewTests: XCTestCase {
	
	private var coordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinator = AppCoordinatorSpy()
		super.setUp()
	}
	
	@MainActor func createAppCoordinator() -> AppCoordinator {
		
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let browser = RestrictedBrowser(
			allowedDomains: ["irealisatie.nl"],
			urlOpener: urlOpenerSpy
		)
		return AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
	}
	
	@MainActor func test_default() throws {
		
		// Given
		let appCoordinator = createAppCoordinator()
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = true
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_childCoordinator() throws {
		
		// Given
		let appCoordinator = createAppCoordinator()
		appCoordinator.showChildCoordinator = true
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_fullscreenCover() throws {
		
		// Given
		let appCoordinator = createAppCoordinator()
		appCoordinator.showChildCoordinator = true
		appCoordinator.showAuthenticationModal = true
		appCoordinator.rootStateForSheet = AppCoordination.State.manualLocalization
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
}
