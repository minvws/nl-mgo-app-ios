/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

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

	var invokedSheetSetter = false
	var invokedSheetSetterCount = 0
	var invokedSheet: AppCoordination.Sheet?
	var invokedSheetList = [AppCoordination.Sheet?]()
	var invokedSheetGetter = false
	var invokedSheetGetterCount = 0
	var stubbedSheet: AppCoordination.Sheet!

	var sheet: AppCoordination.Sheet? {
		set {
			invokedSheetSetter = true
			invokedSheetSetterCount += 1
			invokedSheet = newValue
			invokedSheetList.append(newValue)
		}
		get {
			invokedSheetGetter = true
			invokedSheetGetterCount += 1
			return stubbedSheet
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

	var invokedView = false
	var invokedViewCount = 0
	var invokedViewParameters: (for: AppCoordination.State, Void)?
	var invokedViewParametersList = [(for: AppCoordination.State, Void)]()
	var stubbedViewResult: some View {
		EmptyView()
	}

	func view(for: AppCoordination.State) -> some View {
		stubbedViewResult
			.onAppear { [self] in
				self.invokedView = true
				self.invokedViewCount += 1
				self.invokedViewParameters = (`for`, ())
				self.invokedViewParametersList.append((`for`, ()))
			}
	}
}
