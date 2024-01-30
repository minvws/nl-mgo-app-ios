/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

protocol AppCoordinatorProtocol: ObservableObject {
	
	var path: NavigationStackBackport.NavigationPath { get set }
	
	var sheetContentType: AppCoordination.Sheet? { get set }
	var showSheet: Bool { get set }
	
	func handle(_ action: AppCoordination.Action)
	func start()
}

enum AppCoordination {
	enum Action {
		case finishedLoading
		case nextButtonPressedOnAppIntroduction
		case nextButtonPressedOnPrivacy
		case showPrivacyStatementSheet
		case dismissPrivacyStatementSheet
	}
	
	enum State: Codable {
		case launch
		case appIntroduction
		case privacy
		case dashboard
	}
	
	enum Sheet: Codable {
		case privacyStatement
	}
}

final class AppCoordinator: AppCoordinatorProtocol {
	
	@Published var path: NavigationStackBackport.NavigationPath
	@Published var sheetContentType: AppCoordination.Sheet?
	@Published var showSheet: Bool = false
	
	init(path: NavigationStackBackport.NavigationPath) {
		self.path = path
	}
	
	/// Start the coordinator
	func start() {
		path.append(AppCoordination.State.launch)
	}
	
	/// Handle an action
	/// - Parameter action: an action, i.e. finishedLoading
	func handle(_ action: AppCoordination.Action) {

		switch action {
			case .finishedLoading:
				path.append(AppCoordination.State.appIntroduction)
			case .nextButtonPressedOnAppIntroduction:
				path.append(AppCoordination.State.privacy)
			case .nextButtonPressedOnPrivacy:
				path.append(AppCoordination.State.dashboard)
			case .showPrivacyStatementSheet:
				sheetContentType = AppCoordination.Sheet.privacyStatement
				showSheet = true
			case .dismissPrivacyStatementSheet:
				sheetContentType = nil
				showSheet = false
		}
	}
}
