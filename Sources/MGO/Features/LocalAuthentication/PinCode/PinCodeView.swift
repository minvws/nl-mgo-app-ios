/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// An object to encapsulate the state of the view for access code
struct PinCodeViewState: Equatable {
	
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
	
	/// The key for the back button text
	var backButtonKey: LocalizedStringKey
	
	/// Do we show the forgot access code button?
	var forgotCodeButtonVisible: Bool = false
	
	/// The key for the title
	var title: LocalizedStringKey
	
	/// The key for the body
	var message: LocalizedStringKey
	
	/// Is this message a regular message, or should we show an alert icon?
	var messageType: MessageType = .regular
	
	/// Should we show the popup when biomertric access is locked out?
	var showLockoutPopup: Bool = false
}

class PinCodeViewModel: ObservableObject {
	
	/// The various modes this scene can be run as.
	public enum PinCodeMode: Equatable {
		case creation // Create an access code
		case confirmation // Confirm that access code
		case validation // Validate the acces code (login)
	}
	/// A helper struct to make an enum (PinCodeBoxView.State) identifiable.
	public struct PinCodeBoxState: Identifiable, Hashable {
		
		var id: Int
		var state: PinCodeBoxView.State
		
		func accessibilityLabel(index: Int, count: Int) -> String {
			
			return String(format: String(localized: "pincode.voiceover"), arguments: ["\(index)", "\(count)", state.accessibilityVoiceOverValue()]
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
		case forgotPinCode
	}
	
	/// The mode of this view (creation, validation)
	private var mode: PinCodeMode
	
	/// The number of digits for the access code
	private var numberOfDigits: Int = 5
	
	/// The state of the view
	@Published var state: PinCodeViewState = PinCodeViewState(backButtonKey: "", title: "", message: "")
	
	/// The strength validator for the access code
	private var strengthMeter: PinCodeStrengthValidation
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// Are we in error state?
	private var inErrorState = false
	
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
	@Published var boxStates: [PinCodeBoxState] = []
	
	/// Initializer
	/// - Parameter pinLimit: the pin limit
	/// - Parameter coordinator: the coordinator
	/// - Parameter mode: Which mode should we run in? Creation, Confirmation, Validation?
	/// - Parameter bioMetricType: Which biometric type should we run in? TouchId , FaceId, Optic Id, none?
	/// - Parameter strengthMeter: Access code strength meter
	init(
		coordinator: (any Coordinator)?,
		mode: PinCodeMode,
		pinLimit: Int = 5,
		bioMetricType: () -> LocalAuthentication.BiometricType,
		strengthMeter: PinCodeStrengthValidation = PinCodeStrengthMeter()) {
		
		self.coordinator = coordinator
		self.numberOfDigits = pinLimit
		self.mode = mode
		self.strengthMeter = strengthMeter
		self.state.bioMetricType = bioMetricType()
		
		// Set the state for this mode
		updateState()
		
		// Setup the initial state for the boxes.
		// First box is ready to receive input, the others are empty
		boxStates.append(PinCodeBoxState(id: 0, state: .focus))
		for index in 1 ..< numberOfDigits {
			boxStates.append(PinCodeBoxState(id: index, state: .empty))
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
		state.backButtonKey = ""
		if tooWeak {
			// Setup for access code is too weak
			state.title = "pincode.create.heading"
			state.message = "pincode.create.tooweak"
			state.messageType = .alert
			announce(String(localized: "pincode.create.tooweak.voiceover"))
		} else {
			// Setup for regular access code entry
			state.title = "pincode.create.heading"
			state.message = "pincode.create.subheading"
			state.messageType = .regular
		}
	}
	
	/// Update the state for confirmation mode
	/// - Parameter confirmationMismatch: Does the confirmation code matches the creation code?
	private func updateStateConfirmation(confirmationMismatch: Bool = false) {
		
		state.bioMetricEnabled = false
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonVisible = true
		state.backButtonKey = "pincode.confirm.backbutton"
		if confirmationMismatch {
			// Setup for access codes do not match
			state.title = "pincode.confirm.heading"
			state.message = "pincode.confirm.mismatch"
			state.messageType = .alert
			announce(String(localized: "pincode.confirm.mismatch.voiceover"))
		} else if mode == .confirmation {
			// Setup for access code confirmation
			state.title = "pincode.confirm.heading"
			state.message = "pincode.confirm.subheading"
			state.messageType = .regular
		}
	}
	
	/// Update the state for Validation mode
	/// - Parameter validationMismatch: does the validation code matches the stored accesscode?
	private func updateStateValidation(validationMismatch: Bool = false) {
		
		state.bioMetricEnabled = Current.secureUserSettings.bioMetricAuthenticationEnabled
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonVisible = false
		state.forgotCodeButtonVisible = true
		if validationMismatch {
			// Setup for access codes do not match
			state.title = "pincode.validation.heading"
			state.message = "pincode.validation.wrong"
			state.messageType = .alert
			announce(String(localized: "pincode.validation.wrong.voiceover"))
		} else if mode == .validation {
			// Setup for access code validation
			state.title = "pincode.validation.heading"
			state.message = "pincode.validation.subheading"
			state.messageType = .regular
		}
	}
	
	/// Announce "Field {x}, active"
	/// - Parameter field: the field number
	private func announceActiveField(_ field: Int) {
		let message = String(
			format: String(localized: "pincode.announce.voiceover"),
			arguments: [
				"\(field)",
				String(localized: "pincode.focus.voiceover")
			]
		)
		announce(message)
	}
	
	/// Announce a message to voiceover
	/// - Parameter message: the message to be announced (as a String)
	private func announce(_ message: String) {
		
		logDebug("Announcing: \(message)")
		
		delay(0.25) {
			Current.notificationCenter.post(notification: .announcement, argument: message)
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
				coordinator?.handle(Coordination.Action.backButtonPressed)
			case .onAppear:
				guard mode == .validation && Current.secureUserSettings.bioMetricAuthenticationEnabled else { return }
				delay(0.5) {
					self.showBioMetricLogin()
				}
			case .forgotPinCode:
				coordinator?.handle(Coordination.Action.forgotPinCode)
		}
	}
	
	/// The user pressed on the keyboard to enter a digit
	/// - Parameter value: the value of the digit
	private func buttonPressed(_ value: String) {
		
		if inErrorState {
			accessCode = []
			inErrorState = false
		}
		
		if accessCode.count < numberOfDigits {
			accessCode.append(value)
			Haptic.light()
			updateState()
			if accessCode.count < numberOfDigits {
				announceActiveField(accessCode.count + 1)
			}
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
		Current.secureUserSettings.tempPinCode = code
		coordinator?.handle(Coordination.Action.pinCodeEntered)
		accessCode = []
	}
	
	/// Confirmation entered, compare with the previous value
	private func handleConfirmationCompletion() {
		
		let code = accessCode.joined()
		guard code == Current.secureUserSettings.tempPinCode else {
			// tempPinCode and code do not match. Doh!
			updateStateConfirmation(confirmationMismatch: true)
			setErrorState()
			return
		}
		
		// All ok, store access code and get out of here.
		Haptic.light()
		Current.secureUserSettings.pinCode = code
		coordinator?.handle(Coordination.Action.pinCodeConfirmed)
	}
	
	/// Validation code entered, let's see if we can login
	private func handleValidationCompletion() {
		
		let code = accessCode.joined()
		guard code == Current.secureUserSettings.pinCode else {
			
			setErrorState()
			updateStateValidation(validationMismatch: true)
			return
		}
		coordinator?.handle(Coordination.Action.pinCodeValidated)
	}
	
	/// Something is not ok, make all the boxes red
	private func setErrorState() {
		// All boxes to error state
		for index in 0 ..< numberOfDigits {
			boxStates[index].state = .error
		}
		// Shake it
		Haptic.heavy()
		if !UIAccessibility.isVoiceOverRunning {
			inErrorState = true
		}
	}
	
	/// The user pressed the erase button
	private func erasePressed() {
		
		if accessCode.isNotEmpty {
			Haptic.light()
			inErrorState = false
			accessCode = accessCode.dropLast()
			announceActiveField(accessCode.count + 1)
		}
		updateState()
	}
	
	/// Show the FaceID / TouchID login
	private func showBioMetricLogin() {
		
		_Concurrency.Task {
			await authenticate()
		}
	}
	
	@MainActor
	/// Authenticate the user with biometrics
	private func authenticate() async {
		
		do {
			let validated = try await Current.localAuthenticationProvider.authenticate(
				localizedReason: String(localized: String.LocalizationValue("biometric_setup.dialog.touchid")),
				localizedFallbackTitle: String(localized: String.LocalizationValue("biometric_setup.dialog.fallback"))
			)
			if validated {
				logInfo("Pincode: User has been successfully validated")
				// Fill the boxes to display success
				accessCode = ["0", "0", "0", "0", "0"]
				// Navigate to the next scene after a short delay to let the faceID/touchID animation complete.
				delay(0.8) {
					self.coordinator?.handle(Coordination.Action.pinCodeValidated)
				}
			} else {
				logInfo("PinCode: User has unsuccessfully tried to validate")
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
			logWarning("BioMetric setup lockout")
			state.showLockoutPopup = true
			
		} catch {
			logError("error: \(error)")
		}
	}
}

struct PinCodeView: View {
	
	/// The view model
	@StateObject var viewModel: PinCodeViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Safe Area insets
	@Environment(\.safeAreaInsets) var safeAreaInsets
	
	/// Magic numbers
	private struct ViewTraits {
		enum Title {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 8, trailing: 16)
			static let imageSpacing: CGFloat = 12
		}
		enum ForgotButton {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
		}
		enum Button {
			static let minimumHeight: CGFloat = 44
		}
		enum General {
			static let spacing: CGFloat = 8
			static let horizontalPadding: CGFloat = 16
			static let bottomPadding: CGFloat = 16
		}
		enum Box {
			static let spacing: CGFloat = 12
			static let bottomMargin: CGFloat = 20
		}
		enum Position {
			static let text: CGFloat = 0.38 // Text takes 38% of the screen height.
			static let box: CGFloat = 0.16 // The boxes take 16 %
			static let keyboard: CGFloat = 0.46 // The keyboard the remainder
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		GeometryReader { geometry in
			
			VStack(alignment: .leading, spacing: 0) {
				
				ScrollView {
					Text(viewModel.state.title)
						.rijksoverheidStyle(font: .bold, style: .title)
						.padding(ViewTraits.Title.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.accessibilityAddTraits(.isHeader)
						.fixedSize(horizontal: false, vertical: true)
				
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
							viewModel.reduce(.forgotPinCode)
						}, label: {
							Text("pincode.forgot")
						})
						.buttonStyle(LinkButtonStyle())
						.padding(ViewTraits.ForgotButton.insets)
					}
					
					Spacer()
				}
			}
			.frame(width: geometry.size.width, height: geometry.size.height * ViewTraits.Position.text)
			.position(x: geometry.size.width / 2, y: geometry.size.height * ViewTraits.Position.text / 2 )
			.padding(.top, ViewTraits.Navigation.padding)
			
			HStack(spacing: ViewTraits.Box.spacing) {
				ForEach($viewModel.boxStates, id: \.self) { element in
					PinCodeBoxView(state: element.state)
						.accessibilityHidden(false)
						.accessibilityIdentifier("box \(element.id + 1)")
						.accessibilityLabel(element.wrappedValue.accessibilityLabel(index: element.id + 1, count: viewModel.boxStates.count))
				}
			}
			.padding(.horizontal, ViewTraits.General.horizontalPadding)
			.padding(.bottom, ViewTraits.Box.bottomMargin)
			.frame(maxWidth: .infinity, alignment: .center)
			.frame(width: geometry.size.width, height: geometry.size.height * ViewTraits.Position.box)
			.position(x: geometry.size.width / 2, y: geometry.size.height * ( ViewTraits.Position.text + ViewTraits.Position.box / 2) )
			
			VStack {
				
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
					
					if viewModel.state.bioMetricEnabled {
						// The bioMetric key (face ID, touch ID or optic ID)
						switch viewModel.state.bioMetricType {
							case .none, .unknown:
								Spacer()
									.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight)
								
							case .touchID:
								actionButton(for: .biometricKeyPressed, imageName: "touchid", accessibilityLabel: "pincode.touchid.voiceover")
								
							case .faceID:
								actionButton(for: .biometricKeyPressed, imageName: "faceid", accessibilityLabel: "pincode.faceid.voiceover")
								
							case .opticID:
								actionButton(for: .biometricKeyPressed, imageName: "opticid", accessibilityLabel: "pincode.opticid.voiceover")
						}
					} else {
						Spacer()
							.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight)
						
					}
					
					digitButton(for: "0")
					// The erase button
					actionButton(
						for: .erasePressed,
						imageName: "delete.backward",
						accessibilityLabel: "pincode.erase.voiceover")
					.disabled(!viewModel.state.eraseEnabled)
				}
			}
			.when(safeAreaInsets.bottom == 0) { view in
				view.padding(.bottom, ViewTraits.General.bottomPadding)
			}
			.frame(width: geometry.size.width, height: geometry.size.height * ViewTraits.Position.keyboard)
			.position(x: geometry.size.width / 2, y: geometry.size.height * (1 - ViewTraits.Position.keyboard / 2) )
		}
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.when(viewModel.state.backButtonVisible) { view in
			// Show the backbutton
			view.navigationBarItems(leading: BackButton(viewModel.state.backButtonKey) {
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
		.alert("pincode.lockout", isPresented: $viewModel.state.showLockoutPopup) {
			Button("common.ok") { }
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
		for action: PinCodeViewModel.Action,
		imageName: String,
		accessibilityLabel: LocalizedStringKey) -> some View {
			
			Button {
				viewModel.reduce(action)
			} label: {
				Image(systemName: imageName)
			}
			.buttonStyle(KeyboardIconButtonStyle())
			.accessibilityLabel(accessibilityLabel)
		}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PinCodeView(
			viewModel: PinCodeViewModel(
				coordinator: nil,
				mode: .validation,
				bioMetricType: {
					.touchID // Preview as touch
				}
			)
		)
	}
}
