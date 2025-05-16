/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class AppCoordinatorViewTests: XCTestCase {
	
	private var coordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinator = AppCoordinatorSpy()
		super.setUp()
	}

	func test_default() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_childCoordinator() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		appCoordinator.showChildCoordinator = true
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_fullscreenCover() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		appCoordinator.showChildCoordinator = true
		appCoordinator.showAuthenticationModal = true
		appCoordinator.rootStateForSheet = AppCoordination.State.forgotPinCode
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_fullscreenCover_pathForSheet() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		appCoordinator.showChildCoordinator = true
		appCoordinator.showAuthenticationModal = true
		appCoordinator.rootStateForSheet = AppCoordination.State.forgotPinCode
		appCoordinator.pathForSheet.append(AppCoordination.State.accountRemoved)
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_inspectableSheet_pathForSheet() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		appCoordinator.showChildCoordinator = false
		appCoordinator.showAuthenticationModal = false
		appCoordinator.rootStateForSheet = AppCoordination.State.forgotPinCode
		appCoordinator.pathForSheet.append(AppCoordination.State.accountRemoved)
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		takeSnapShots(content: sut)
	}
}
