/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AccountRemovedViewModel: ObservableObject {
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case restart
	}
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .restart:
				coordinator?.handle(.restart)
		}
	}
}

struct AccountRemovedView: View {
	
	/// The view model
	@StateObject var viewModel: AccountRemovedViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic numbers
	private struct ViewTraits {
		enum Text {
			static let spacing: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhoneCheck),
				heading: "account_removed.heading",
				subHeading: "account_removed.subheading",
				textAlignment: .leading,
				textSpacing: ViewTraits.Text.spacing,
				titleStyle: .title
			)
			.padding(.top, ViewTraits.Navigation.padding)
			
		} bottomView: {
			CallToActionButton("account_removed.action") {
				viewModel.reduce(.restart)
			}
			.accessibilityIdentifier("account_removed.action")
			.padding(ViewTraits.Button.insets)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(false)
		.background(theme.backgroundPrimary)
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AccountRemovedView(
			viewModel: AccountRemovedViewModel(
				coordinator: nil
			)
		)
	}
}
