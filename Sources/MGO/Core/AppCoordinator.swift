/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

protocol AppCoordinatorProtocol: ObservableObject {
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var sheet: AppCoordination.Sheet? { get set }
	
	/// Handle an incoming action from any of the view models
	/// - Parameter action: an AppCoordination Action
	func handle(_ action: AppCoordination.Action)
	
	/// Start the cooridinator
	func start()
}

enum AppCoordination {
	
	/// A list of all the action an app coordinator can do
	enum Action {
		case finishedLoading
		case nextButtonPressedOnAppIntroduction
		case nextButtonPressedOnPrivacy
		case showPrivacyStatementSheet
		case dismissPrivacyStatementSheet
	}
	
	/// A list of all the view states the app coordinator can show
	enum State: Codable {
		case launch
		case appIntroduction
		case privacy
		case dashboard
	}
	
	/// A list of all the sheets the app coordinator can show
	enum Sheet: Codable {
		case privacyStatement
	}
}

final class AppCoordinator: AppCoordinatorProtocol {
	
	/// The navigation path
	@Published var path: NavigationStackBackport.NavigationPath
	
	/// The content type for the sheet
	@Published var sheet: AppCoordination.Sheet?
	
	/// Initializer
	/// - Parameter path: Navigation Path
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
				sheet = AppCoordination.Sheet.privacyStatement
			case .dismissPrivacyStatementSheet:
				sheet = nil
		}
	}
}
