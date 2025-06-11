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
	
	var invokedPathForSheetSetter = false
	var invokedPathForSheetSetterCount = 0
	var invokedPathForSheet: NavigationStackBackport.NavigationPath?
	var invokedPathForSheetList = [NavigationStackBackport.NavigationPath]()
	var invokedPathForSheetGetter = false
	var invokedPathForSheetGetterCount = 0
	var stubbedPathForSheet: NavigationStackBackport.NavigationPath!
	
	var pathForSheet: NavigationStackBackport.NavigationPath {
		set {
			invokedPathForSheetSetter = true
			invokedPathForSheetSetterCount += 1
			invokedPathForSheet = newValue
			invokedPathForSheetList.append(newValue)
		}
		get {
			invokedPathForSheetGetter = true
			invokedPathForSheetGetterCount += 1
			return stubbedPathForSheet
		}
	}
	
	var invokedRootStateForSheetSetter = false
	var invokedRootStateForSheetSetterCount = 0
	var invokedRootStateForSheet: SettingsCoordination.State?
	var invokedRootStateForSheetList = [SettingsCoordination.State?]()
	var invokedRootStateForSheetGetter = false
	var invokedRootStateForSheetGetterCount = 0
	var stubbedRootStateForSheet: SettingsCoordination.State!
	
	var rootStateForSheet: SettingsCoordination.State? {
		set {
			invokedRootStateForSheetSetter = true
			invokedRootStateForSheetSetterCount += 1
			invokedRootStateForSheet = newValue
			invokedRootStateForSheetList.append(newValue)
		}
		get {
			invokedRootStateForSheetGetter = true
			invokedRootStateForSheetGetterCount += 1
			return stubbedRootStateForSheet
		}
	}
	
	var invokedView = false
	var invokedViewCount = 0
	var invokedViewParameters: (state: SettingsCoordination.State?, Void)?
	var invokedViewParametersList = [(state: SettingsCoordination.State?, Void)]()
	var stubbedViewResult: some View {
		EmptyView()
	}
	
	func view(for state: SettingsCoordination.State?) -> some View {
		stubbedViewResult
			.onAppear { [self] in
				self.invokedView = true
				self.invokedViewCount += 1
				self.invokedViewParameters = (state, ())
				self.invokedViewParametersList.append((state, ()))
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
