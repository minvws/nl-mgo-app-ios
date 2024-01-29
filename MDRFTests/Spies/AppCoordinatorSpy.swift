/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzFoundation
import GifzUI
@testable import MDRF

class AppCoordinatorSpy: AppCoordinatorProtocol {

	var invokedPathSetter = false
	var invokedPathSetterCount = 0
	var invokedPath: NavigationStackBackport.NavigationPath?
	var invokedPathList = [NavigationStackBackport.NavigationPath]()
	var invokedPathGetter = false
	var invokedPathGetterCount = 0
	var stubbedPath: NavigationStackBackport.NavigationPath!

	var path: NavigationStackBackport.NavigationPath {
		set {
			invokedPathSetter = true
			invokedPathSetterCount += 1
			invokedPath = newValue
			invokedPathList.append(newValue)
		}
		get {
			invokedPathGetter = true
			invokedPathGetterCount += 1
			return stubbedPath
		}
	}

	var invokedHandle = false
	var invokedHandleCount = 0
	var invokedHandleParameters: (action: AppCoordination.Action, Void)?
	var invokedHandleParametersList = [(action: AppCoordination.Action, Void)]()

	func handle(_ action: AppCoordination.Action) {
		invokedHandle = true
		invokedHandleCount += 1
		invokedHandleParameters = (action, ())
		invokedHandleParametersList.append((action, ()))
	}

	var invokedStart = false
	var invokedStartCount = 0

	func start() {
		invokedStart = true
		invokedStartCount += 1
	}
}
