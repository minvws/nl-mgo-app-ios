/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

import LocalAuthentication

class BioMetricSetupViewModel: ObservableObject {
	
	/// All possible actions
	enum Action {
		case proceedWithBioMetric // Enable biometric access
		case proceedWithoutBioMetric // Skip the biometric setup
		case showTouchIDPopup // FaceID has a native popup, we want something similar for Touch ID.
	}
	
	/// A struct to capture the various states.
	struct State {
		public var bioMetricType: LocalAuthentication.BiometricType
		public var showTouchPopup: Bool = false
		public var showLockoutPopup: Bool = false
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// What kind of key should we  display (face ID, touch ID, optic ID)
	private var bioMetricType: LocalAuthentication.BiometricType = .none
	
	/// The state of the view
	@Published var state: State = State(bioMetricType: .none)
	
	/// Initializer
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
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		switch action {
			case .proceedWithBioMetric:
				_Concurrency.Task {
					await authenticate()
				}
				
			case .proceedWithoutBioMetric:
				finishedWithoutBioMetric()
				
			case .showTouchIDPopup:
				state.showTouchPopup = true
		}
	}
	
	/// The user finished this page with bio metric access
	private func finishedWithBioMetric() {
		
		// Do use biometric authentication
		Current.secureUserSettings.bioMetricAuthenticationEnabled = true
		// We are done
		coordinator?.handle(Coordination.Action.didFinishLocalAuthentication)
	}
	
	/// The user finished this page without bio metric access
	private func finishedWithoutBioMetric() {
		
		// Do not use biometric authentication
		Current.secureUserSettings.bioMetricAuthenticationEnabled = false
		// We are done
		coordinator?.handle(Coordination.Action.didFinishLocalAuthentication)
	}
	
	@MainActor
	/// Authenticate the user with biometrics
	private func authenticate() async {
		
		do {
			let authenticated = try await Current.localAuthenticationProvider.authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_setup.dialog.touchid")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_setup.dialog.fallback"))
			)
			if authenticated {
				finishedWithBioMetric()
			}
		} catch LocalAuthenticationError.canceled {
			// Cancelled, stay on the scene
			logWarning("User cancelled the biometric request.")
			Current.secureUserSettings.bioMetricAuthenticationEnabled = false
			
		} catch LocalAuthenticationError.authenticationFailed {
			logWarning("Authentication Failed")
			Current.secureUserSettings.bioMetricAuthenticationEnabled = false
			
		} catch LocalAuthenticationError.userFallback {
			logWarning("User selected password option")
			finishedWithoutBioMetric()
			
		} catch LocalAuthenticationError.declined {
			logWarning("User declined biometric access")
			finishedWithoutBioMetric()
			
		} catch LocalAuthenticationError.lockout {
			logWarning("BioMetric setup lockout")
			state.showLockoutPopup = true
			Current.secureUserSettings.bioMetricAuthenticationEnabled = false
			
		} catch {
			logError("error: \(error)")
			Current.secureUserSettings.bioMetricAuthenticationEnabled = false
		}
	}
}

struct BioMetricSetupView: View {
	
	/// The view model
	@StateObject var viewModel: BioMetricSetupViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let top: CGFloat = 100
			static let size: CGFloat = 100
		}
		enum Title {
			static let insets = EdgeInsets( top: 74, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			static let spacing: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		
		let bioMetricType = viewModel.state.bioMetricType
		
		ScrollViewWithFixedBottom {
			
			topView(bioMetricType)
			
		} bottomView: {
			
			bottomView(bioMetricType)
		}
		.navigationBarBackButtonHidden(true)
		.alert("biometric_setup.dialog.heading", isPresented: $viewModel.state.showTouchPopup) {
			Button("biometric_setup.dialog.cancel", role: .cancel) { viewModel.reduce(.proceedWithoutBioMetric) }
			Button("common.ok") { viewModel.reduce(.proceedWithBioMetric) }
		} message: {
			Text("biometric_setup.dialog.subheading")
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
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Get the top view
	/// - Parameter bioMetricType: the biometric type
	/// - Returns: view for the top part
	@ViewBuilder private func topView(_ bioMetricType: LocalAuthentication.BiometricType) -> some View {

		VStack {
			HStack {
				Spacer()
				getBioMetricImage(type: bioMetricType)
					.foregroundStyle(theme.interactionPrimaryDefaultBackground)
					.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
					.padding(.top, ViewTraits.Image.top)
				Spacer()
			}
			
			Text(LocalizedStringKey(bioMetricTypedHeading(bioMetricType)))
				.rijksoverheidStyle(font: .bold, style: .title)
				.padding(ViewTraits.Title.insets)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier("biometric_setup.heading")
			
			Text(LocalizedStringKey(bioMetricTypedIntro(bioMetricType)))
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(ViewTraits.Text.insets)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityIdentifier("biometric_setup.subheading")
		}
		.padding(.top, ViewTraits.Navigation.padding)
	}
	
	/// Get the image for this biometric type
	/// - Parameter type: the biometric type
	/// - Returns: the image for this type (or empty view if non exists)
	@ViewBuilder private func getBioMetricImage(type: LocalAuthentication.BiometricType) -> some View {
		switch type {
			case .none, .unknown:
				// Should not happen
				EmptyView()
					.logDebug("No image for \(type)")
			case .touchID:
				Image(systemName: "touchid").resizable().scaledToFit()
			case .faceID:
				Image(systemName: "faceid").resizable().scaledToFit()
			case .opticID:
				Image(systemName: "opticid").resizable().scaledToFit()
		}
	}
	
	/// Interpolate a string with the biometric type
	/// - Parameters:
	///   - key: the key for the localized text "Continue with %@"
	///   - type: the biometric type
	/// - Returns: interpolated string "Continue with FaceID"
	private func getBioMetricTypeInterpolatedText(_ key: String, type: LocalAuthentication.BiometricType) -> String {
		
		let formatString = String(localized: String.LocalizationValue(key))
		let typeString = String(localized: String.LocalizationValue(bioMetricTypedString(type)))
		
		return String(format: formatString, typeString)
	}
	
	/// Get the biometric type as a string
	/// - Parameter type: biometric type
	/// - Returns: biometric type as a string
	private func bioMetricTypedString(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				// Should not happen
				_ = logWarning("No translation for \(type)")
				return ""
			case .touchID:
				return "biometric_setup.touchid"
			case .faceID:
				return "biometric_setup.faceid"
			case .opticID:
				return "biometric_setup.opticid"
		}
	}
	
	/// Get the intro text for a biometric type
	/// - Parameter type: biometric type
	/// - Returns: the right intro text.
	private func bioMetricTypedHeading(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				// Should not happen
				_ = logWarning("No translation for \(type)")
				return ""
			case .touchID:
				return "biometric_setup.touchid.heading"
			case .faceID:
				return "biometric_setup.faceid.heading"
			case .opticID:
				return "biometric_setup.opticid.heading"
		}
	}
	
	/// Get the intro text for a biometric type
	/// - Parameter type: biometric type
	/// - Returns: the right intro text.
	private func bioMetricTypedIntro(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				// Should not happen
				_ = logWarning("No translation for \(type)")
				return ""
			case .touchID:
				return "biometric_setup.touchid.subheading"
			case .faceID:
				return "biometric_setup.faceid.subheading"
			case .opticID:
				return "biometric_setup.opticid.subheading"
		}
	}
	
	/// Get the call to action buttons view
	/// - Returns: View containing the call to action buttons
	@ViewBuilder func bottomView(_ bioMetricType: LocalAuthentication.BiometricType) -> some View {
		
		VStack(spacing: ViewTraits.Button.spacing) {
			
			CallToActionButton("common.skip", style: .secondary) {
				viewModel.reduce(.proceedWithoutBioMetric)
			}
				.accessibilityIdentifier("common.skip")
			
			CallToActionButton(LocalizedStringKey(getBioMetricTypeInterpolatedText("biometric_setup.button.with_biometric", type: bioMetricType))) {
				if bioMetricType == .touchID {
					viewModel.reduce(.showTouchIDPopup)
				} else {
					viewModel.reduce(.proceedWithBioMetric)
				}
			}
			.accessibilityIdentifier("biometric_setup.button.with_biometric")
		}
		.padding(ViewTraits.Button.insets)
	}
}

#Preview {
	
	let bioMetricType: () -> LocalAuthentication.BiometricType = { .faceID }
	
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: bioMetricType
			)
		)
	}
}

#Preview {
	
	let bioMetricType: () -> LocalAuthentication.BiometricType = { .touchID }
	
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: bioMetricType
			)
		)
	}
}

#Preview {
	
	let bioMetricType: () -> LocalAuthentication.BiometricType = { .opticID }
	
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: bioMetricType
			)
		)
	}
}
