/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class DashboardCoordinatorSpy: DashboardCoordinatorProtocol {

	var invokedFirstTabPathSetter = false
	var invokedFirstTabPathSetterCount = 0
	var invokedFirstTabPath: NavigationStackBackport.NavigationPath?
	var invokedFirstTabPathList = [NavigationStackBackport.NavigationPath]()
	var invokedFirstTabPathGetter = false
	var invokedFirstTabPathGetterCount = 0
	var stubbedFirstTabPath: NavigationStackBackport.NavigationPath!

	var firstTabPath: NavigationStackBackport.NavigationPath {
		set {
			invokedFirstTabPathSetter = true
			invokedFirstTabPathSetterCount += 1
			invokedFirstTabPath = newValue
			invokedFirstTabPathList.append(newValue)
		}
		get {
			invokedFirstTabPathGetter = true
			invokedFirstTabPathGetterCount += 1
			return stubbedFirstTabPath
		}
	}

	var invokedSecondTabPathSetter = false
	var invokedSecondTabPathSetterCount = 0
	var invokedSecondTabPath: NavigationStackBackport.NavigationPath?
	var invokedSecondTabPathList = [NavigationStackBackport.NavigationPath]()
	var invokedSecondTabPathGetter = false
	var invokedSecondTabPathGetterCount = 0
	var stubbedSecondTabPath: NavigationStackBackport.NavigationPath!

	var secondTabPath: NavigationStackBackport.NavigationPath {
		set {
			invokedSecondTabPathSetter = true
			invokedSecondTabPathSetterCount += 1
			invokedSecondTabPath = newValue
			invokedSecondTabPathList.append(newValue)
		}
		get {
			invokedSecondTabPathGetter = true
			invokedSecondTabPathGetterCount += 1
			return stubbedSecondTabPath
		}
	}
	
	var invokedThirdTabPathSetter = false
	var invokedThirdTabPathSetterCount = 0
	var invokedThirdTabPath: NavigationStackBackport.NavigationPath?
	var invokedThirdTabPathList = [NavigationStackBackport.NavigationPath]()
	var invokedThirdTabPathGetter = false
	var invokedThirdTabPathGetterCount = 0
	var stubbedThirdTabPath: NavigationStackBackport.NavigationPath!

	var thirdTabPath: NavigationStackBackport.NavigationPath {
		set {
			invokedThirdTabPathSetter = true
			invokedThirdTabPathSetterCount += 1
			invokedThirdTabPath = newValue
			invokedThirdTabPathList.append(newValue)
		}
		get {
			invokedThirdTabPathGetter = true
			invokedThirdTabPathGetterCount += 1
			return stubbedThirdTabPath
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
	var invokedRootStateForSheet: DashboardCoordination.State?
	var invokedRootStateForSheetList = [DashboardCoordination.State?]()
	var invokedRootStateForSheetGetter = false
	var invokedRootStateForSheetGetterCount = 0
	var stubbedRootStateForSheet: DashboardCoordination.State!

	var rootStateForSheet: DashboardCoordination.State? {
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

	var invokedViewState = false
	var invokedViewStateCount = 0
	var invokedViewStateParameters: (for: DashboardCoordination.State?, Void)?
	var invokedViewStateParametersList = [(for: DashboardCoordination.State?, Void)]()
	var stubbedViewStateResult: some View {
		EmptyView()
	}

	func viewState(for: DashboardCoordination.State?) -> some View {
		stubbedViewStateResult
			.onAppear { [self] in
				self.invokedViewState = true
				self.invokedViewStateCount += 1
				self.invokedViewStateParameters = (`for`, ())
				self.invokedViewStateParametersList.append((`for`, ()))
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
	
	var invokedSelectedTabSetter = false
	var invokedSelectedTabSetterCount = 0
	var invokedSelectedTab: Int?
	var invokedSelectedTabList = [Int]()
	var invokedSelectedTabGetter = false
	var invokedSelectedTabGetterCount = 0
	var stubbedSelectedTab: Int! = 0

	var selectedTab: Int {
		set {
			invokedSelectedTabSetter = true
			invokedSelectedTabSetterCount += 1
			invokedSelectedTab = newValue
			invokedSelectedTabList.append(newValue)
		}
		get {
			invokedSelectedTabGetter = true
			invokedSelectedTabGetterCount += 1
			return stubbedSelectedTab
		}
	}
}
