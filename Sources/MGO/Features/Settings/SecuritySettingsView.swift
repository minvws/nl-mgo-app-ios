/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SecuritySettingsViewModel: BaseViewModel {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		
		case biometricEnabled(Bool)
	}
	
	/// The state of the view
	struct State {
		
		/// What kind of biometric do we have
		public var bioMetricType: LocalAuthentication.BiometricType
		
		/// Should we show the lockout page (too many attempts)
		public var showLockoutPopup: Bool = false
		
		/// Is the biometric authentication enabled
		public var bioMetricAuthenticationEnabled: Bool = false
	}
	
	/// What kind of key should we  display (face ID, touch ID, optic ID)
	private var bioMetricType: LocalAuthentication.BiometricType = .none
	
	/// The state of the view
	@Published var state: State = State(bioMetricType: .none)
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Create a Security Settings Viewmodel
	/// - Parameter coordinator: the coordinator
	/// - Parameter bioMetricType: what biometric type do we have? (FaceID, TouchID, OpticID)
	@MainActor init(
		coordinator: (any Coordinator)?,
		bioMetricType: () -> LocalAuthentication.BiometricType) {
			
		self.bioMetricType = bioMetricType()
		super.init(coordinator: coordinator)
		updateState()
	}
	
	/// Update the state
	private func updateState() {
		state.bioMetricType = bioMetricType
		state.bioMetricAuthenticationEnabled = secureUserSettings.bioMetricAuthenticationEnabled
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: SecuritySettingsViewModel.Action) {
		
		if case .biometricEnabled(let enabled) = action {
			if enabled {
				_Concurrency.Task(priority: .userInitiated) { [weak self] in
					await self?.authenticate()
				}
			} else {
				// Do not use biometric authentication
				secureUserSettings.bioMetricAuthenticationEnabled = false
				updateState()
			}
		}
	}
	
	@MainActor
	/// Authenticate the user with biometrics
	private func authenticate() async {
		
		do {
			let authenticated = try await Container.shared.localAuthenticationProvider().authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_setup.dialog.touchid")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_setup.dialog.fallback"))
			)
			secureUserSettings.bioMetricAuthenticationEnabled = authenticated
			updateState()
		
		} catch {
			logError("error: \(error)")
			secureUserSettings.bioMetricAuthenticationEnabled = false
			
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
		enum Navigation {
			static let padding: CGFloat = 24
		}
		enum Footer {
			static let inset: EdgeInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
		}
	}
	
	var body: some View {
		
		List {
			Section {
				toggleView()
			} footer: {
				Text("settings.security.biometric.subheading")
					.typography(.bodySmall)
					.foregroundStyle(theme.labels.secondary)
					.listRowInsets(ViewTraits.Footer.inset)
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
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding, edges: .top)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("settings.security.heading")
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// The view for the toggle
	/// - Returns: toggle view
	@ViewBuilder private func toggleView() -> some View {
		
		Toggle(isOn: $viewModel.state.bioMetricAuthenticationEnabled) {
			Text(LocalizedStringKey(label(viewModel.state.bioMetricType)))
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
		}
			.toggleStyle(.switch)
			.tint(theme.actions.solid.background)
			.accessibilityIdentifier("settings.security.toggle")
	}
	
	/// Get the label for a biometric type
	/// - Parameter type: the biometric type
	/// - Returns: String
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
		SecuritySettingsView(
			viewModel: SecuritySettingsViewModel(
				coordinator: nil,
				bioMetricType: { .faceID }
			)
		)
	}
}
