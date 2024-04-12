/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

import LocalAuthentication

class BioMetricSetupViewModel: ObservableObject {
	
	enum Action {
		case proceedWithBioMetric // Enable biometric access
		case proceedWithoutBioMetric // Skip the biometric setup
		case showTouchIDPopup // FaceID has a native popup, we want something similar for Touch ID.
	}
	
	struct State {
		public var bioMetricType: LocalAuthentication.BiometricType
		public var showTouchPopup: Bool = false
	}
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// What kind of key should we  dispaly (face ID, touch ID, optic ID)
	private var bioMetricType: LocalAuthentication.BiometricType = .none
	
	@Published var state: State = State(bioMetricType: .none)
	
	/// Initialzier
	/// - Parameter pinLimit: the pinLimt
	init(
		coordinator: (any AppCoordinatorProtocol)?,
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
				SwiftUI.Task {
					await authenticate()
				}
			
			case .proceedWithoutBioMetric:
				finishedWithoutBioMetric()
			
			case .showTouchIDPopup:
				state.showTouchPopup = true
		}
	}
	
	private func finishedWithBioMetric() {
		
		// Do use biometric authentication
		Current.secureUserSettings.bioMetricAuthenticationEnabled = true
		// We are done
		coordinator?.handle(.didFinishLocalAuthentication)
	}
	
	private func finishedWithoutBioMetric() {
		
		// Do not use biometric authentication
		Current.secureUserSettings.bioMetricAuthenticationEnabled = false
		// We are done
		coordinator?.handle(.didFinishLocalAuthentication)
	}
	
	@MainActor
	private func authenticate() async {
		
		do {
			let authenticated = try await Current.localAuthenticationProvider.authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_popup_touchid_description")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_popup_fallback"))
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
			logWarning("BioMetric setup lockaout")
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
			static let top: CGFloat = 50
			static let size: CGFloat = 60
		}
		enum Title {
			static let insets = EdgeInsets( top: 35, leading: 16, bottom: 16, trailing: 16)
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
		
		let bioMetricType = viewModel.state.bioMetricType
		
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ScrollViewWithFixedBottom(content: {
				
				HStack {
					Spacer()
					getBioMetricImage(type: bioMetricType)
						.foregroundStyle(theme.actionPrimaryBackground)
						.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
						.padding(.top, ViewTraits.Image.top)
					Spacer()
				}
				
				Text(getBioMetricTypeInterpolatedText("biometric_title", type: bioMetricType))
					.rijksoverheidStyle(font: .bold, style: .title)
					.padding(ViewTraits.Title.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text(LocalizedStringKey(bioMetricTypedIntro(bioMetricType)))
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(ViewTraits.Text.insets)
					.frame(maxWidth: .infinity, alignment: .topLeading)
				
			}, bottomView: {
				
				VStack(spacing: ViewTraits.Button.spacing) {
					
					CallToActionButton(LocalizedStringKey(getBioMetricTypeInterpolatedText("biometric_button_without_biometric", type: bioMetricType)), style: .secondary) {
						viewModel.reduce(.proceedWithoutBioMetric)
					}
					
					CallToActionButton(LocalizedStringKey(getBioMetricTypeInterpolatedText("biometric_button_with_biometric", type: bioMetricType))) {
						if bioMetricType == .touchID {
							viewModel.reduce(.showTouchIDPopup)
						} else {
							viewModel.reduce(.proceedWithBioMetric)
						}
					}
				}
				.padding(ViewTraits.Button.insets)
			})
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarTitleDisplayMode(.inline)
		.alert("biometric_alert_title", isPresented: $viewModel.state.showTouchPopup) {
			Button("biometric_alert_cancel", role: .cancel) { viewModel.reduce(.proceedWithoutBioMetric) }
			Button("general_ok") { viewModel.reduce(.proceedWithBioMetric) }
		} message: {
			Text("biometric_alert_body")
		}
	}
	
	@ViewBuilder func getBioMetricImage(type: LocalAuthentication.BiometricType) -> some View {
		switch type {
			case .none, .unknown:
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
	
	private func getBioMetricTypeInterpolatedText(_ key: String, type: LocalAuthentication.BiometricType) -> String {
	
		let formatString = String(localized: String.LocalizationValue(key))
		let typeString = String(localized: String.LocalizationValue(bioMetricTypedString(type)))

		return String(format: formatString, typeString)
	}
	
	private func bioMetricTypedString(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				_ = logWarning("No translation for \(type)")
				return ""
			case .touchID:
				return "biometric_touchid"
			case .faceID:
				return "biometric_faceid"
			case .opticID:
				return "biometric_opticid"
		}
	}
	
	private func bioMetricTypedIntro(_ type: LocalAuthentication.BiometricType) -> String {
		switch type {
			case .none, .unknown:
				_ = logWarning("No translation for \(type)")
				return ""
			case .touchID:
				return "biometric_body_touchid"
			case .faceID:
				return "biometric_body_faceid"
			case .opticID:
				return "biometric_body_opticid"
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: {
					.faceID
				}
			)
		)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: {
					.touchID
				}
			)
		)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		BioMetricSetupView(
			viewModel: BioMetricSetupViewModel(
				coordinator: nil,
				bioMetricType: {
					.opticID
				}
			)
		)
	}
}
