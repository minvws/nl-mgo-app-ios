/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzFoundation
import GifzTest
import GifzUI
@testable import MDRF

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
		let contentView = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: contentView, as: .image)
	}
	
	func test_dashboard() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
		
		// When
		let contentView = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: contentView, as: .image)
	}
	
	func test_appIntroduction() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.appIntroduction])
		
		// When
		let contentView = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: contentView, as: .image)
	}
	
	func test_privacy() {
		
		// Given
		coordinator.stubbedPath = NavigationStackBackport.NavigationPath([AppCoordination.State.privacy])
		
		// When
		let contentView = AppCoordinatorView<AppCoordinatorSpy>(appCoordinator: coordinator)
		
		// Then
		assertSnapshot(of: contentView, as: .image)
	}
}
