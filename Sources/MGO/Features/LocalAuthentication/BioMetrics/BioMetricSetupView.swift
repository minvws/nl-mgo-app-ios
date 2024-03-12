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
		case proceedWithBioMetric
		case proceedWithoutBioMetric
	}
	
	enum State {
		case idle(bioMetricType: LocalAuthentication.BiometricType, popupEnable: Bool)
	}
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// What kind of key should we  dispaly (face ID, touch ID, optic ID)
	private var bioMetricType: LocalAuthentication.BiometricType = .none
	
	@Published var state: State = .idle(bioMetricType: .none, popupEnable: false)
	
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
		state = .idle(bioMetricType: bioMetricType, popupEnable: false)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		logDebug("Action: \(action)")
		switch action {
			case .proceedWithBioMetric:
				break
			case .proceedWithoutBioMetric:
				coordinator?.handle(.didFinishLocalAuthentication)
		}
	}
}

struct BioMetricSetupView: View {

	/// The view model
	@StateObject var viewModel: BioMetricSetupViewModel
	
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
		}
	}

	var body: some View {
		
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			if case let BioMetricSetupViewModel.State.idle(bioMetricType, _) = viewModel.state {
				
				ScrollViewWithFixedBottom(content: {
					
					HStack {
						Spacer()
						getBioMetricImage(type: bioMetricType)
							.foregroundStyle(Color.Styleguide.Blue.skyBlue)
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
					
					VStack {
						
						CallToActionButton(LocalizedStringKey(getBioMetricTypeInterpolatedText("biometric_button_without_biometric", type: bioMetricType)), style: .secondary) {
							viewModel.reduce(.proceedWithoutBioMetric)
						}
						
						CallToActionButton(LocalizedStringKey(getBioMetricTypeInterpolatedText("biometric_button_with_biometric", type: bioMetricType))) {
							viewModel.reduce(.proceedWithBioMetric)
						}
					}
					.padding(ViewTraits.Button.insets)
				})
			}
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarTitleDisplayMode(.inline)
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
