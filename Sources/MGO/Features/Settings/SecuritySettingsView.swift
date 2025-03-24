/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SecuritySettingsViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		
		case backButtonPressed
		case biometricEnabled(Bool)
	}
	
	struct State {
		public var bioMetricType: LocalAuthentication.BiometricType
		public var showLockoutPopup: Bool = false
		public var bioMetricAuthenticationEnabled: Bool = false
	}
	
	/// What kind of key should we  display (face ID, touch ID, optic ID)
	private var bioMetricType: LocalAuthentication.BiometricType = .none
	
	/// The state of the view
	@Published var state: State = State(bioMetricType: .none)
	
	/// Create a Security Settings Viewmodel
	/// - Parameter coordinator: the coordinator
	/// - Parameter bioMetricType: what biometric type do we have? (FaceID, TouchID, OpticID)
	init(
		coordinator: (any Coordinator)?,
		bioMetricType: () -> LocalAuthentication.BiometricType) {
			
		self.coordinator = coordinator
		self.bioMetricType = bioMetricType()
		updateState()
	}
	
	/// Update the state
	private func updateState() {
		state.bioMetricType = bioMetricType
		state.bioMetricAuthenticationEnabled = Current.secureUserSettings.bioMetricAuthenticationEnabled
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SecuritySettingsViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case let .biometricEnabled(enabled):
				if enabled {
					_Concurrency.Task {
						await authenticate()
					}
				} else {
					// Do not use biometric authentication
					Current.secureUserSettings.bioMetricAuthenticationEnabled = false
					updateState()
				}
		}
	}
	
	@MainActor
	/// Authenticate the user with biometrics
	private func authenticate() async {
		
		do {
			let authenticated = try await Current.localAuthenticationProvider.authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_setup.dialog.touchid")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_setup.dialog.fallback"))
			)
			Current.secureUserSettings.bioMetricAuthenticationEnabled = authenticated
			updateState()
		
		} catch {
			logError("error: \(error)")
			Current.secureUserSettings.bioMetricAuthenticationEnabled = false
			
			switch error {
				case LocalAuthenticationError.canceled:
					logWarning("User cancelled the biometric request.")
				case LocalAuthenticationError.authenticationFailed:
					logWarning("Authentication Failed")
				case LocalAuthenticationError.userFallback:
					logWarning("User selected password option")
				case LocalAuthenticationError.declined:
					logWarning("User declined biometric access")
				case LocalAuthenticationError.lockout:
					logWarning("BioMetric setup lockout")
					state.showLockoutPopup = true
				default:
					break
			}
			updateState()
		}
	}
}

struct SecuritySettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: SecuritySettingsViewModel
	
	/// The application appearance for light / dark / system mode
	@AppStorage("AppAppearance") private var selectedAppearance: AppAppearance = .system
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
		enum Icon {
			static let size: CGFloat = 24.0
			static let padding: CGFloat = 16.0
			static let cornerRadius: CGFloat = 6.0
		}
		enum Chevron {
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
		
		List {
			Section {
				
				Toggle(isOn: $viewModel.state.bioMetricAuthenticationEnabled) {
					Text(LocalizedStringKey(label(viewModel.state.bioMetricType)))
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentPrimary)
				}.toggleStyle(.switch)
					.tint(theme.interactionPrimaryDefaultBackground)
			}
			footer: {
				Text("setting.security.subheading")
					.rijksoverheidStyle(font: .regular, style: .callout)
					.foregroundStyle(theme.contentSecondary)
			}
			.onChange(of: viewModel.state.bioMetricAuthenticationEnabled) { newValue in
				viewModel.reduce(.biometricEnabled(newValue))
			}
			
		}
		.alert("pincode.lockout", isPresented: $viewModel.state.showLockoutPopup) {
			Button("common.ok") { /* no action for lockout available */ }
		} message: {
			switch viewModel.state.bioMetricType {
				case .none, .unknown:
					// Should not happen
					EmptyView()
				case .touchID:
					Text("pincode.touchid.lockout")
				case .faceID:
					Text("pincode.faceid.lockout")
				case .opticID:
					Text("pincode.opticid.lockout")
			}
		}
		.backportScrollContentBackground(.hidden)
		.backportListSectionSpacing(32)
		.backportVerticalContentMargins(0)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("settings.security.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	private func label(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				// Should not happen
				_ = logWarning("No translation for \(type)")
				return ""
			case .faceID:
				return "settings.security.faceId"
			case .touchID:
				return "settings.security.touchId"
			case .opticID:
				return "settings.security.opticId"
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		SettingsView(viewModel: SettingsViewModel(coordinator: nil))
	}
}
