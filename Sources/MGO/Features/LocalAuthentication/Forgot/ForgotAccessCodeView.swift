/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class ForgotAccessCodeViewModel: ObservableObject {
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case cancelButtonPressed
		case loginWithDigiD
	}
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .cancelButtonPressed:
				coordinator?.handle(.dismissForgotAccessCode)
			case .loginWithDigiD:
				coordinator?.handle(.remoteAuthentication)
		}
	}
}

struct ForgotAccessCodeView: View {
	
	/// The view model
	@StateObject var viewModel: ForgotAccessCodeViewModel
	
	/// Magic numbers
	private struct ViewTraits {
		enum Title {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
		}
		enum Button {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ScrollViewWithFixedBottom {
				Text("forgot_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.padding(ViewTraits.Title.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text("forgot_body")
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(ViewTraits.Text.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
			} bottomView: {
				VStack(spacing: ViewTraits.Button.spacing) {
					
					CallToActionButton("general_cancel", style: .secondary) {
						viewModel.reduce(.cancelButtonPressed)
					}
					.tag("general_cancel")
					
					CallToActionButton("forgot_action_digid") {
						viewModel.reduce(.loginWithDigiD)
					}
					.tag("forgot_action_digid")
				}
				.padding(ViewTraits.Button.insets)
			}
		}
	}
}
