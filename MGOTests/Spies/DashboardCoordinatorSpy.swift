/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

class DashboardCoordinatorSpy: DashboardCoordinatorProtocol {

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

	var invokedView = false
	var invokedViewCount = 0
	var invokedViewParameters: (for: DashboardCoordination.State?, Void)?
	var invokedViewParametersList = [(for: DashboardCoordination.State?, Void)]()
	var stubbedViewStateResult: some View {
		EmptyView()
	}
	
	func view(for: DashboardCoordination.State?) -> some View {
		stubbedViewStateResult
			.onAppear { [self] in
				self.invokedView = true
				self.invokedViewCount += 1
				self.invokedViewParameters = (`for`, ())
				self.invokedViewParametersList.append((`for`, ()))
			}
	}
}
