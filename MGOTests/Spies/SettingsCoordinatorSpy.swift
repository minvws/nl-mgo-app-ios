/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class SettingsCoordinatorSpy: SettingsCoordinatorProtocol {

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
	
	var invokedView = false
	var invokedViewCount = 0
	var invokedViewParameters: (for: SettingsCoordination.State?, Void)?
	var invokedViewParametersList = [(for: SettingsCoordination.State?, Void)]()
	var stubbedViewResult: some View {
		EmptyView()
	}
	
	func view(for: SettingsCoordination.State?) -> some View {
		stubbedViewResult
			.onAppear { [self] in
				self.invokedView = true
				self.invokedViewCount += 1
				self.invokedViewParameters = (`for`, ())
				self.invokedViewParametersList.append((`for`, ()))
			}
	}

	var invokedHandle = false
	var invokedHandleCount = 0
	var invokedHandleParameters: (action: Coordination.Action, Void)?
	var invokedHandleParametersList = [(action: Coordination.Action, Void)]()

	func handle(_ action: Coordination.Action) {
		invokedHandle = true
		invokedHandleCount += 1
		invokedHandleParameters = (action, ())
		invokedHandleParametersList.append((action, ()))
	}
}
