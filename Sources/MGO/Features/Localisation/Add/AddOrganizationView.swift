/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

extension Notification.Name {
	static let clearSearch = Notification.Name("nl.mijngezondheidsomgeving.clearSearch")
}

struct AddOrganizationViewState {
	
	/// The name to search on
	var name: String = "" {
		didSet {
			if name.isNotEmpty {
				nameError = ""
			}
		}
	}
	
	/// The error when the name is empty
	var nameError: LocalizedStringKey = ""

	/// The city to search on
	var city: String = "" {
		didSet {
			if city.isNotEmpty {
				cityError = ""
			}
		}
	}
	
	/// The error when the city is empty
	var cityError: LocalizedStringKey = ""
}

class AddOrganizationViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		
		case clear
		case closeSheet
		case endEditing
		case search
	}
	
	/// The state for this view
	@Published var state: AddOrganizationViewState = AddOrganizationViewState()

	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
		
		setupObservers()
	}
	
	/// Setup all the observers
	private func setupObservers() {
		
		// Listen for reset notification
		Current.notificationCenter.addObserver(forName: .clearSearch, object: nil, queue: OperationQueue.main) { _ in
			self.reduce(.clear)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AddOrganizationViewModel.Action) {
		
		switch action {
			
			case .clear:
				state.city = ""
				state.name = ""
			
			case .search:
				guard validateState() else {
					/// Announce the errors
					if state.nameError != "" {
						announce(String(localized: "add_organization.error_missing_name_voiceover"))
					} else if state.cityError != "" {
						announce(String(localized: "add_organization.error_missing_city_voiceover"))
					}
					return
				}
			coordinator?.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": state.city, "name": state.name]))
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
		
			case .endEditing:
				UIApplication.shared.endEditing()
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
			state.nameError = "add_organization.error_missing_name"
		}
		if let sanitized = Sanitizer.strip(state.city), sanitized.isNotEmpty {
			state.cityError = ""
			state.city = sanitized
		} else {
			allFieldsAreFilled = false
			state.cityError = "add_organization.error_missing_city"
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

struct AddOrganizationView: View {
	
	/// The view model
	@StateObject var viewModel: AddOrganizationViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	@FocusState var isCityFieldFocused: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Image {
			static let spacing: CGFloat = 8
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack {
				
				Text("add_organization.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.General.padding)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("add_organization.heading")
				
				InputField(
					input: $viewModel.state.name,
					errorMessage: $viewModel.state.nameError,
					title: "add_organization.name",
					required: true
				)
				.padding(.bottom, ViewTraits.General.padding)
				.accessibilityIdentifier("add_organization.name")
				.submitLabel(.next)
				.onSubmit {
					// Make the next field focussed
					isCityFieldFocused = true
				}
				
				InputField(
					input: $viewModel.state.city,
					errorMessage: $viewModel.state.cityError,
					title: "add_organization.city",
					required: true,
					isFieldFocused: _isCityFieldFocused
				)
				.padding(.bottom, ViewTraits.General.padding)
				.accessibilityIdentifier("add_organization.city")
				.submitLabel(.search)
				.onSubmit {
					isCityFieldFocused = false
					// Search
					viewModel.reduce(.search)
				}
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			CallToActionButton("common.search") {
				viewModel.reduce(.search)
			}
			.padding(ViewTraits.General.padding)
			.accessibilityIdentifier("common.search")
		}
		.onTapGesture {
			_ = logDebug("Tapping outside the input")
			viewModel.reduce(.endEditing)
		}
		.resignKeyboardOnDragGesture()
		
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(false)
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton {
					viewModel.reduce(.closeSheet)
				}
		})

		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}

#Preview {
	NavigationView {
		AddOrganizationView(viewModel: AddOrganizationViewModel(coordinator: nil))
	}
}
