/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	var invokedRootStateForSheet: AppCoordination.State?
	var invokedRootStateForSheetList = [AppCoordination.State?]()
	var invokedRootStateForSheetGetter = false
	var invokedRootStateForSheetGetterCount = 0
	var stubbedRootStateForSheet: AppCoordination.State!

	var rootStateForSheet: AppCoordination.State? {
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

	var invokedRootStateSetter = false
	var invokedRootStateSetterCount = 0
	var invokedRootState: AppCoordination.State?
	var invokedRootStateList = [AppCoordination.State]()
	var invokedRootStateGetter = false
	var invokedRootStateGetterCount = 0
	var stubbedRootState: AppCoordination.State!

	var rootState: AppCoordination.State {
		set {
			invokedRootStateSetter = true
			invokedRootStateSetterCount += 1
			invokedRootState = newValue
			invokedRootStateList.append(newValue)
		}
		get {
			invokedRootStateGetter = true
			invokedRootStateGetterCount += 1
			return stubbedRootState
		}
	}

	var invokedShowAuthenticationModalSetter = false
	var invokedShowAuthenticationModalSetterCount = 0
	var invokedShowAuthenticationModal: Bool?
	var invokedShowAuthenticationModalList = [Bool]()
	var invokedShowAuthenticationModalGetter = false
	var invokedShowAuthenticationModalGetterCount = 0
	var stubbedShowAuthenticationModal: Bool! = false

	var showAuthenticationModal: Bool {
		set {
			invokedShowAuthenticationModalSetter = true
			invokedShowAuthenticationModalSetterCount += 1
			invokedShowAuthenticationModal = newValue
			invokedShowAuthenticationModalList.append(newValue)
		}
		get {
			invokedShowAuthenticationModalGetter = true
			invokedShowAuthenticationModalGetterCount += 1
			return stubbedShowAuthenticationModal
		}
	}

	var invokedShowChildCoordinatorSetter = false
	var invokedShowChildCoordinatorSetterCount = 0
	var invokedShowChildCoordinator: Bool?
	var invokedShowChildCoordinatorList = [Bool]()
	var invokedShowChildCoordinatorGetter = false
	var invokedShowChildCoordinatorGetterCount = 0
	var stubbedShowChildCoordinator: Bool! = false

	var showChildCoordinator: Bool {
		set {
			invokedShowChildCoordinatorSetter = true
			invokedShowChildCoordinatorSetterCount += 1
			invokedShowChildCoordinator = newValue
			invokedShowChildCoordinatorList.append(newValue)
		}
		get {
			invokedShowChildCoordinatorGetter = true
			invokedShowChildCoordinatorGetterCount += 1
			return stubbedShowChildCoordinator
		}
	}

	var invokedView = false
	var invokedViewCount = 0
	var invokedViewParameters: (for: AppCoordination.State?, Void)?
	var invokedViewParametersList = [(for: AppCoordination.State?, Void)]()
	var stubbedViewResult: some View {
		EmptyView()
	}
	
	func view(for: AppCoordination.State?) -> some View {
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
