/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class PrivacyStatementViewModel: ObservableObject {
	
	/// The app coordintator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: PrivacyStatementViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(AppCoordination.Action.backButtonPressed)
		}
	}
}

struct PrivacyStatementView: View {
	
	/// The View Model
	@StateObject var viewModel: PrivacyStatementViewModel
	
	/// Global dismiss closure
	@Environment(\.dismiss) var dismiss
	
	/// Magic Numbers
	private struct ViewTraits {
		
		enum VStack {
			static let spacing: CGFloat = 16
		}
		
		enum PrivacyStatement {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ScrollView {
				
				VStack(alignment: .leading, spacing: ViewTraits.VStack.spacing) {
					
					Text("privacy_statement_title")
						.rijksoverheidStyle(font: .bold, style: .title2)
						.accessibilityAddTraits(.isHeader)
					
					SplittedText(key: "privacy_statement_body")
						.rijksoverheidStyle(font: .regular, style: .body)
				}
			}
			.foregroundColor(Color.Styleguide.black)
			.padding(ViewTraits.PrivacyStatement.insets)
			
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton("general_close") {
			viewModel.reduce(.backButtonPressed)
		})
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PrivacyStatementView(
			viewModel: PrivacyStatementViewModel(
				coordinator: nil
			)
		)
	}
}
