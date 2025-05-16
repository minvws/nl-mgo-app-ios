/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class ForgotPinCodeViewModel: ObservableObject {
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case cancelButtonPressed
		case recreateAccount
		case showDialog
		case cancelDialog
	}
	
	@Published var showDialog = false
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .cancelButtonPressed:
				coordinator?.handle(Coordination.Action.dismissForgotPinCode)
			case .recreateAccount:
				coordinator?.handle(Coordination.Action.recreateAccount)
			case .showDialog:
				showDialog = true
			case .cancelDialog:
				showDialog = false
		}
	}
}

struct ForgotPinCodeView: View {
	
	/// The view model
	@StateObject var viewModel: ForgotPinCodeViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
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
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			VStack {
				Text("forgot_pincode.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.padding(ViewTraits.Title.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("forgot_pincode.heading")
				
				Text("forgot_pincode.subheading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(ViewTraits.Text.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityIdentifier("forgot_pincode.subheading")
			}
				.padding(.top, ViewTraits.Navigation.padding)
			
		} bottomView: {
			
			bottomView()
		}
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.alert("forgot_pincode.dialog.heading", isPresented: $viewModel.showDialog) {
			Button("common.no", role: .cancel) { viewModel.reduce(.cancelDialog) }.accessibilityIdentifier("common.no")
			Button("common.yes", role: .destructive) { viewModel.reduce(.recreateAccount) }.accessibilityIdentifier("common.yes")
		} message: {
			Text("forgot_pincode.dialog.subheading")
		}
	}
	
	/// Get the call to action buttons view
	/// - Returns: View containing the call to action buttons
	@ViewBuilder func bottomView() -> some View {
		
		VStack(spacing: ViewTraits.Button.spacing) {
			CallToActionButton("forgot_pincode.button", style: .secondary) {
				viewModel.reduce(.showDialog)
			}
			.accessibilityIdentifier("forgot_pincode.button")
			
			CallToActionButton("common.cancel") {
				viewModel.reduce(.cancelButtonPressed)
			}
			.accessibilityIdentifier("common.cancel")
			
		}
		.padding(ViewTraits.Button.insets)
	}
}
