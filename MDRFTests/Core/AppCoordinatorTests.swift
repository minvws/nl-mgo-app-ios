/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzTest
import GifzFoundation
@testable import MDRF

final class AppCoordinatorTests: XCTestCase {
	
	private var sut: AppCoordinator!
	
	override func setUp() {
		
		sut = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		
		super.setUp()
	}
	
	func test_coordinatorStart_pathShouldContainLaunch() {
		
		// Given
		
		// When
		sut.start()
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.launch])
	}
	
	func test_coordinatorHandle_actionFinishedLoading_pathShouldContainDashboard() {
		
		// Given
		
		// When
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([AppCoordination.State.dashboard])
	}
	
	func test_coordinatorHandle_startAndHandle_shouldHaveTwoElements() {
		
		// Given
		
		// When
		sut.start()
		sut.handle(AppCoordination.Action.finishedLoading)
		
		// Then
		expect(self.sut.path.count) == 2
	}
}
