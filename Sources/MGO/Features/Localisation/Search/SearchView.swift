/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct SearchViewState {
	
	/// The name to search on
	var name: String = "Huisarts" {
		didSet {
			if name.isNotEmpty {
				nameError = ""
			}
		}
	}
	
	/// The error when the name is empty
	var nameError: LocalizedStringKey = ""

	/// The city to search on
	var city: String = "Den Haag" {
		didSet {
			if city.isNotEmpty {
				cityError = ""
			}
		}
	}
	
	/// The error when the city is empty
	var cityError: LocalizedStringKey = ""
}

class SearchViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case search
		case backButtonPressed
	}
	
	@Published var state: SearchViewState = SearchViewState()

	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SearchViewModel.Action) {
		
		switch action {
			case .search:
				guard validateState() else {
					/// Announce the errors
					if state.nameError != "" {
						announce(String(localized: "searchhp_name_error_voiceover"))
					} else if state.cityError != "" {
						announce(String(localized: "searchhp_city_error_voiceover"))
					}
					return
				}
				coordinator?.handle(.search(city: state.city, name: state.name))
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
		}
	}
	
	/// Validate the state
	/// - Returns: True if all fields are valid
	private func validateState() -> Bool {
		
		var allFieldsAreFilled = true
		if let sanitized = Sanitizer.strip(state.name), sanitized.isNotEmpty {
			state.nameError = ""
			state.name = sanitized
		} else {
			allFieldsAreFilled = false
			state.nameError = "searchhp_name_error"
		}
		if let sanitized = Sanitizer.strip(state.city), sanitized.isNotEmpty {
			state.cityError = ""
			state.city = sanitized
		} else {
			allFieldsAreFilled = false
			state.cityError = "searchhp_city_error"
		}
		return allFieldsAreFilled
	}
	
	/// Announce a message to voiceover
	/// - Parameter message: the message to be announced (as a String)
	private func announce(_ message: String) {
		
		logDebug("Announcing: \(message)")
		
		delay(0.25) {
			Current.notificationCenter.post(notification: .announcement, argument: message)
		}
	}
}

struct SearchView: View {
	
	/// The view model
	@StateObject var viewModel: SearchViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Image {
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
		
			ScrollViewWithFixedBottom {
				
				VStack {
					
					Text("searchhp_title")
						.rijksoverheidStyle(font: .bold, style: .title)
						.foregroundStyle(theme.contentPrimary)
						.padding(.bottom, ViewTraits.General.padding)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.accessibilityAddTraits(.isHeader)
					
					InputField(
						input: $viewModel.state.name,
						errorMessage: $viewModel.state.nameError,
						title: "searchhp_name"
					)
						.padding(.bottom, ViewTraits.General.padding)
					
					InputField(
						input: $viewModel.state.city,
						errorMessage: $viewModel.state.cityError,
						title: "searchhp_city"
					)
						.padding(.bottom, ViewTraits.General.padding)
				}
				.padding(.horizontal, ViewTraits.General.padding)
				
			} bottomView: {
				CallToActionButton("searchhp_action") {
					viewModel.reduce(.search)
				}
				.tag("search")
				.padding(ViewTraits.General.padding)
			}
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
	}
}

#Preview {
	NavigationView {
		SearchView(viewModel: SearchViewModel(coordinator: nil))
	}
}
