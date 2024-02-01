/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class AppCoordinatorViewTests: XCTestCase {
	
	private var coordinator: AppCoordinatorSpy!
	
	override func setUp() {
		
		coordinator = AppCoordinatorSpy()
		super.setUp()
	}
	
	func test_launch() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.launch])
		
		// When
		let sut = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	func test_dashboard() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
		
		// When
		let sut = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	func test_appIntroduction() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		
		// When
		let sut = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	func test_privacy() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.privacy])
		
		// When
		let sut = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: sut, as: .image)
	}
	
	func test_privacyStatement() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		appCoordinator.sheet = .privacyStatement
		
		// Then
		let value = try sut.inspect().find(viewWithTag: "privacyStatement")
		expect(value) != nil
	}
}

// MARK: - InspectableSheet -

// See https://github.com/nalexn/ViewInspector/blob/0.9.11/guide_popups.md#sheet
extension InspectableSheet: PopupPresenter { }
