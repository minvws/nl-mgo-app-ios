/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// An object to encapsulate the state of the view for access code
struct AccessCodeViewState: Equatable {
	
	/// Various types of messages
	enum MessageType: Equatable {
		case regular
		case alert
	}
	
	/// Is the biometric key (face ID, touch ID) enabled?
	var bioMetricEnabled: Bool = false
	
	/// What kind of key should we  dispaly (face ID, touch ID, optic ID)
	var bioMetricType: LocalAuthentication.BiometricType = .none
	
	/// Is the erase button enabled? Disabled when the access code is empty
	var eraseEnabled: Bool = false
	
	/// Is the back visible?
	var backButtonVisible: Bool = false
	
	/// Do we show the forgot access code button?
	var forgotCodeButtonVisible: Bool = false
	
	/// The key for the title
	var title: LocalizedStringKey
	
	/// The key for the body
	var message: LocalizedStringKey
	
	/// Is this message a regular message, or should we show an alert icon?
	var messageType: MessageType = .regular
}

class AccessCodeViewModel: ObservableObject {
	
	/// The various modes this scene can be run as.
	public enum AccessCodeMode: Equatable {
		case creation // Create an access code
		case confirmation // Confirm that accces code
		case validation // Validate the acces code (login)
	}
	/// A helper struct to make an enum (AccessCodeBoxView.State) identificable.
	public struct AccessCodeBoxState: Identifiable, Hashable {
		
		var id: Int
		var state: AccessCodeBoxView.State
		
		func accessibilityLabel(index: Int, count: Int) -> String {
			
			return String(format: String(localized: "acccescode_box_voiceover"), arguments: ["\(index)", "\(count)", state.accessibilityValue()]
			)
		}
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case buttonPressed(value: String)
		case erasePressed
		case biometricKeyPressed
		case backButtonPressed
		case onAppear
		case forgotAccessCode
	}
	
	/// The mode of this view (creation, validation)
	private var mode: AccessCodeMode
	
	/// The number of digits for the access code
	private var numberOfDigits: Int = 5
	
	/// The state of the view
	@Published var state: AccessCodeViewState = AccessCodeViewState(title: "", message: "")
	
	/// Tha strenth validator for the access code
	private var strengthMeter: AccessCodeStrengthValidation
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// The access code
	private var accessCode: [String] = [] {
		didSet {
			for index in 0 ..< numberOfDigits {
				if accessCode.count < index {
					// A box that is yet to be filled
					boxStates[index].state = .empty
				} else if accessCode.count == index {
					// The box that is currently being filled
					boxStates[index].state = .focus
				} else if accessCode.count == index + 1 {
					// A box that just has been filled..
					boxStates[index].state = oldValue.count < accessCode.count ? .filling : .filled
				} else if accessCode.count > index {
					// A box that is already filled.
					boxStates[index].state = .filled
				}
			}
		}
	}
	
	/// The state for each of the digits
	@Published var boxStates: [AccessCodeBoxState] = []
	
	/// Initialzier
	/// - Parameter pinLimit: the pinLimt
	init(
		coordinator: (any AppCoordinatorProtocol)?,
		mode: AccessCodeMode,
		pinLimit: Int = 5,
		bioMetricType: () -> LocalAuthentication.BiometricType,
		strengthMeter: AccessCodeStrengthValidation = AccessCodeStrengthMeter()) {
		
		self.coordinator = coordinator
		self.numberOfDigits = pinLimit
		self.mode = mode
		self.numberOfDigits = pinLimit
		self.strengthMeter = strengthMeter
		self.state.bioMetricType = bioMetricType()
		
		// Set the state for this mode
		updateState()
	
		// Setup the initial state for the boxes.
		boxStates.append(AccessCodeBoxState(id: 0, state: .focus))
		for index in 1 ..< numberOfDigits {
			boxStates.append(AccessCodeBoxState(id: index, state: .empty))
		}
	}
	
	/// Update the state
	private func updateState() {
		switch mode {
			case .creation:
				updateStateEntry()
			case .confirmation:
				updateStateConfirmation()
			case .validation:
				updateStateValidation()
		}
	}
	
	/// Update the state for creation mode
	/// - Parameters:
	///   - tooWeak: is the created code too weak?
	private func updateStateEntry(tooWeak: Bool = false) {
		
		state.bioMetricEnabled = false
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonVisible = false
		if tooWeak {
			// Setup for access code is too weak
			state.title = "accesscode_create_title"
			state.message = "accesscode_tooweak_body"
			state.messageType = .alert
			announce(String(localized: "accesscode_tooweak_body_voiceover"))
		} else {
			// Setup for regular access code entry
			state.title = "accesscode_create_title"
			state.message = "accesscode_create_body"
			state.messageType = .regular
		}
	}
	
	/// Update the state for confirmation mode
	/// - Parameter confirmationMismatch: Does the confirmation code matches the creation code?
	private func updateStateConfirmation(confirmationMismatch: Bool = false) {
		
		state.bioMetricEnabled = false
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonVisible = true
		if confirmationMismatch {
			// Setup for access codes do not match
			state.title = "accesscode_confirmation_title"
			state.message = "accesscode_mismatch_body"
			state.messageType = .alert
			announce(String(localized: "accesscode_mismatch_body_voiceover"))
		} else if mode == .confirmation {
			// Setup for access code confirmation
			state.title = "accesscode_confirmation_title"
			state.message = "accesscode_confirmation_body"
			state.messageType = .regular
		}
	}
	
	/// Udpate the state for Validation mode
	/// - Parameter validationMismatch: does the validation code matches the stored accesscode?
	private func updateStateValidation(validationMismatch: Bool = false) {
		
		state.bioMetricEnabled = Current.secureUserSettings.bioMetricAuthenticationEnabled
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonVisible = true
		state.forgotCodeButtonVisible = true
		if validationMismatch {
			// Setup for access codes do not match
			state.title = "accesscode_validation_title"
			state.message = "accesscode_wrong_body"
			state.messageType = .alert
			announce(String(localized: "accesscode_wrong_body_voiceover"))
		} else if mode == .validation {
			// Setup for access code validation
			state.title = "accesscode_validation_title"
			state.message = "accesscode_validation_body"
			state.messageType = .regular
		}
	}
	
	/// Announce a message to voiceover
	/// - Parameter message: the message to be announced (as a String)
	func announce(_ message: String) {
		
		logDebug("Announcing: \(message)")
		
		delay(0.5) {
			UIAccessibility.post(notification: .announcement, argument: message)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		switch action {
			case .buttonPressed(let value):
				buttonPressed(value)
			case .erasePressed:
				erasePressed()
			case .biometricKeyPressed:
				showBioMetricLogin()
			case .backButtonPressed:
				coordinator?.handle(AppCoordination.Action.backButtonPressed)
			case .onAppear:
				guard mode == .validation && Current.secureUserSettings.bioMetricAuthenticationEnabled else { return }
				delay(0.5) {
					self.showBioMetricLogin()
				}
			case .forgotAccessCode:
				coordinator?.handle(.forgotAccessCode)
		}
	}
	
	/// The user pressed on the keyboard to enter a digit
	/// - Parameter value: the value of the digit
	private func buttonPressed(_ value: String) {
		
		if accessCode.count < numberOfDigits {
			accessCode.append(value)
			Haptic.light()
			updateState()
			
			// Announce 'Field x from 5, filled'
			let message = String(
				format: String(localized: "acccescode_box_voiceover"),
				arguments: [
					"\(accessCode.count)",
					"\(numberOfDigits)",
					String(localized: "acccescode_box_voiceover_filled")
				]
			)
			announce(message)
		}
		if accessCode.count == numberOfDigits {
			updateState()
			if mode == .creation {
				handleCreationCompletion()
			} else if mode == .confirmation {
				handleConfirmationCompletion()
			} else if mode == .validation {
				handleValidationCompletion()
			}
		}
	}
	
	/// All digits are entered. Check  for strength
	private func handleCreationCompletion() {
		
		let code = accessCode.joined()
		guard strengthMeter.validate(code) else {
			
			// Show too weak message
			updateStateEntry(tooWeak: true)
			setErrorState()
			return
		}
		
		// All ok, store temp and move to confirmation
		Haptic.light()
		Current.secureUserSettings.tempAccessCode = code
		coordinator?.handle(.accessCodeEntered)
		accessCode = []
	}
	
	/// Confirmation entered, compare with the previous value
	private func handleConfirmationCompletion() {
		
		let code = accessCode.joined()
		guard code == Current.secureUserSettings.tempAccessCode else {
			// tempAccessCode and code do not match. Doh!
			updateStateConfirmation(confirmationMismatch: true)
			setErrorState()
			return
		}
		
		// All ok, store access code and get out of here.
		Haptic.light()
		Current.secureUserSettings.accessCode = code
		coordinator?.handle(.accessCodeConfirmed)
	}
	
	/// Validation code entered, let's see if we can login
	private func handleValidationCompletion() {
		
		let code = accessCode.joined()
		guard code == Current.secureUserSettings.accessCode else {
			
			setErrorState()
			updateStateValidation(validationMismatch: true)
			delay(1.0) {
				self.accessCode = []
			}
			return
		}
		coordinator?.handle(.accessCodeValidated)
	}
	
	/// Something is not ok, make all the boxes red
	private func setErrorState() {
		// All boxes to error state
		for index in 0 ..< numberOfDigits {
			boxStates[index].state = .error
		}
		// Shake it
		Haptic.heavy()
	}
	
	/// The user pressed the erate button
	private func erasePressed() {
		if accessCode.isNotEmpty {
			accessCode = accessCode.dropLast()
			// Announce 'Field x from 5, empty'
			let message = String(
				format: String(localized: "acccescode_box_voiceover"),
				arguments: [
					"\(accessCode.count + 1)",
					"\(numberOfDigits)",
					String(localized: "acccescode_box_voiceover_emptied")
				]
			)
			announce(message)
		}
		updateState()
	}
	
	/// Show the FaceID / TouchID login
	private func showBioMetricLogin() {
		
		SwiftUI.Task {
			await authenticate()
		}
	}
	
	@MainActor
	private func authenticate() async {
		
		do {
			let validated = try await Current.localAuthenticationProvider.authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_popup_touchid_description")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_popup_fallback"))
			)
			if validated {
				logInfo("AccessCode: User has been successfully validated")
				// Fill the boxes to display success
				accessCode = ["0", "0", "0", "0", "0"]
				// Navigate to the next scene after a short delay to let the faceID/touchID animation complete.
				delay(0.8) {
					self.coordinator?.handle(.accessCodeValidated)
				}
			} else {
				logInfo("AccessCode: User has unsuccessfully tried to validate")
				setErrorState()
			}
		} catch LocalAuthenticationError.canceled {
			// Cancelled, stay on the scene
			logWarning("User cancelled the biometric request.")
			
		} catch LocalAuthenticationError.authenticationFailed {
			logWarning("Authentication Failed")
			setErrorState()
			
		} catch LocalAuthenticationError.userFallback {
			logWarning("User selected password option")
		
		} catch LocalAuthenticationError.declined {
			logWarning("User declined biometric access")
			
		} catch LocalAuthenticationError.lockout {
			logWarning("BioMetric setup lockaout")
			
		} catch {
			logError("error: \(error)")
		}
	}
}

struct AccessCodeView: View {
	
	/// The view model
	@StateObject var viewModel: AccessCodeViewModel
	
	/// Magic numbers
	private struct ViewTraits {
		enum Title {
			static let insetsWithNavBar = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
			static let insets = EdgeInsets( top: 48, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
			static let imageSpacing: CGFloat = 8
		}
		enum ForgotButton {
			static let insets = EdgeInsets( top: 8, leading: 16, bottom: 0, trailing: 16)
		}
		enum Button {
			static let minimumHeight: CGFloat = 44
		}
		enum General {
			static let spacing: CGFloat = 8
			static let horizontalPadding: CGFloat = 16
		}
		enum Box {
			static let spacing: CGFloat = 12
			static let bottomMargin: CGFloat = 22
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack(alignment: .leading, spacing: 0) {
				Text(viewModel.state.title)
					.rijksoverheidStyle(font: .bold, style: .title)
					.if(viewModel.state.backButtonVisible) { view in
							view.padding(ViewTraits.Title.insetsWithNavBar)
					}
					.if(!viewModel.state.backButtonVisible) { view in
						if #available(iOS 16, *) {
							view.padding(ViewTraits.Title.insets)
						} else {
							view.padding(ViewTraits.Title.insetsWithNavBar)
						}
					}
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.fixedSize(horizontal: false, vertical: true)
				
				ScrollView {
					switch viewModel.state.messageType {
						
						case .regular:
							Text(viewModel.state.message)
								.rijksoverheidStyle(font: .regular, style: .body)
								.padding(ViewTraits.Text.insets)
								.frame(maxWidth: .infinity, alignment: .topLeading)
						
						case .alert:
							HStack(alignment: .top, spacing: ViewTraits.Text.imageSpacing) {
								Image(ImageResource.Notification.error)
								
								Text(viewModel.state.message)
									.rijksoverheidStyle(font: .regular, style: .body)
									.frame(maxWidth: .infinity, alignment: .topLeading)
							}
							.padding(ViewTraits.Text.insets)
							.accessibilityElement(children: .combine)
					}
					
					if viewModel.state.forgotCodeButtonVisible {
						Button(action: {
							viewModel.reduce(.forgotAccessCode)
						}, label: {
							Text("biometric_forgot_accesscode")
						})
						.buttonStyle(LinkButtonStyle())
						.padding(ViewTraits.ForgotButton.insets)
					}
				}
				
				Spacer()
				
				VStack(spacing: ViewTraits.General.spacing) {
					
					HStack(spacing: ViewTraits.Box.spacing) {
						ForEach($viewModel.boxStates, id: \.self) { element in
							AccessCodeBoxView(state: element.state)
								.accessibilityHidden(false)
								.accessibilityIdentifier("box \(element.id + 1)")
								.accessibilityLabel(element.wrappedValue.accessibilityLabel(index: element.id + 1, count: viewModel.boxStates.count))
						}
					}
					.padding(.bottom, ViewTraits.Box.bottomMargin)
					
					Group {
						HStack(spacing: ViewTraits.General.spacing) {
							digitButton(for: "1")
							digitButton(for: "2")
							digitButton(for: "3")
						}
						
						HStack(spacing: ViewTraits.General.spacing) {
							digitButton(for: "4")
							digitButton(for: "5")
							digitButton(for: "6")
						}
						
						HStack(spacing: ViewTraits.General.spacing) {
							digitButton(for: "7")
							digitButton(for: "8")
							digitButton(for: "9")
						}
						
						HStack(spacing: ViewTraits.General.spacing) {
							
							// The bioMetric key (face ID, touch ID or optic ID)
							switch viewModel.state.bioMetricType {
								case .none, .unknown:
									Spacer()
										.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight)
								
								case .touchID:
									actionButton(for: .biometricKeyPressed, imageName: "touchid", accessibilityLabel: "accesscode_button_touchid")
										.disabled(!viewModel.state.bioMetricEnabled)
								
								case .faceID:
									actionButton(for: .biometricKeyPressed, imageName: "faceid", accessibilityLabel: "accesscode_button_faceid")
										.disabled(!viewModel.state.bioMetricEnabled)
								
								case .opticID:
									actionButton(for: .biometricKeyPressed, imageName: "opticid", accessibilityLabel: "accesscode_button_opticid")
										.disabled(!viewModel.state.bioMetricEnabled)
							}
							
							digitButton(for: "0")
							// The erase button
							actionButton(for: .erasePressed, imageName: "delete.backward", accessibilityLabel: "accesscode_button_erase")
								.disabled(!viewModel.state.eraseEnabled)
						}
					}
					.padding(.horizontal, ViewTraits.General.horizontalPadding) // For the whole keyboard
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.if(viewModel.state.backButtonVisible) { view in
			// Show the backbutton
			view.navigationBarItems(leading: BackButton("general_previous") {
				viewModel.reduce(.backButtonPressed)
			})
		}
		.onAppear {
			// Fix to portrait mode
			if UIDevice.current.userInterfaceIdiom == .phone {
				OrientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
			}
			viewModel.reduce(.onAppear)
		}
		.onDisappear {
			// And unlock the forced portrait mode on exit.
			if UIDevice.current.userInterfaceIdiom == .phone {
				OrientationUtility.unlockOrientation()
			}
		}
	}
	
	/// Create a button for a digit (0 ... 9)
	/// - Parameter value: the digit to display
	/// - Returns: a button with the digit
	@ViewBuilder func digitButton(for value: String) -> some View {
		
		Button {
			viewModel.reduce(.buttonPressed(value: value))
		} label: {
			Text(value)
		}
		.buttonStyle(KeyboardButtonStyle())
	}
	
	/// Create an action button (erase, use faceID etc)
	/// - Parameters:
	///   - action: the action to perform
	///   - imageName: the system image
	///   - accessibilityLabel: the  label for voice over
	/// - Returns: an action button
	@ViewBuilder func actionButton(
		for action: AccessCodeViewModel.Action,
		imageName: String,
		accessibilityLabel: LocalizedStringKey) -> some View {
			
		Button {
			viewModel.reduce(action)
		} label: {
			Image(systemName: imageName)
		}
		.buttonStyle(KeyboardButtonStyle())
		.accessibilityLabel(accessibilityLabel)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AccessCodeView(
			viewModel: AccessCodeViewModel(
				coordinator: nil,
				mode: .validation,
				bioMetricType: {
					.touchID // Preview as touch
				}
			)
		)
	}
}
