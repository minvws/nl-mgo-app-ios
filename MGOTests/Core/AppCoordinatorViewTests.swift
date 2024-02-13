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

	func test_default() throws {
		
		// Given
		let appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
		
		// When
		let sut = AppCoordinatorView<AppCoordinator>(appCoordinator: appCoordinator)
		
		// Then
		let value = try sut.inspect().find(viewWithTag: "app_title")
		expect(value) != nil
	}
}
