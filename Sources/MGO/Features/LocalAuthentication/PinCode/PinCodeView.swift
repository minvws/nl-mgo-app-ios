/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class PinCodeViewModel: ObservableObject {
	
	/// The various modes this scene can be run as.
	public enum PinCodeMode: Equatable {
		case creation // Create an access code
		case confirmation // Confirm that access code
		case validation(lockOut: Bool) // Validate the access code (login)
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
	
	/// Should we show the back button?
	private var backButtonVisible = false
	
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
		backButtonVisible: Bool = true,
		pinLimit: Int = 5,
		bioMetricType: () -> LocalAuthentication.BiometricType,
		strengthMeter: PinCodeStrengthValidation = PinCodeStrengthMeter()) {
		
		self.coordinator = coordinator
		self.numberOfDigits = pinLimit
		self.mode = mode
		self.backButtonVisible = backButtonVisible
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
		state.backButtonVisible = backButtonVisible
		state.backButtonKey = "common.previous"
		state.title = "pincode.create.heading"
		state.message = "pincode.create.subheading"
		if tooWeak {
			// Setup for access code is too weak
			state.error = "pincode.create.tooweak"
			announce(Sanitizer.sanitize(String(localized: "pincode.create.tooweak")))
		} else {
			state.error = nil
		}
	}
	
	/// Update the state for confirmation mode
	/// - Parameter confirmationMismatch: Does the confirmation code matches the creation code?
	private func updateStateConfirmation(confirmationMismatch: Bool = false) {
		
		state.bioMetricEnabled = false
		state.backButtonVisible = true
		state.backButtonKey = "pincode.confirm.backbutton"
		state.title = "pincode.confirm.heading"
		state.message = "pincode.confirm.subheading"
		if confirmationMismatch {
			// Setup for access codes do not match
			state.error = "pincode.confirm.mismatch"
			announce(Sanitizer.sanitize(String(localized: "pincode.confirm.mismatch")))
		} else if mode == .confirmation {
			state.error = nil
		}
	}
	
	/// Update the state for Validation mode
	/// - Parameter validationMismatch: does the validation code matches the stored accesscode?
	private func updateStateValidation(validationMismatch: Bool = false) {
		
		state.bioMetricEnabled = Current.secureUserSettings.bioMetricAuthenticationEnabled
		state.backButtonVisible = false
		state.forgotCodeButtonVisible = true
		state.textAlignment = .center
		state.title = "pincode.validation.heading"
		state.message = "pincode.validation.subheading"
		if validationMismatch {
			// Setup for access codes do not match
			state.error = "pincode.validation.wrong"
			announce(Sanitizer.sanitize(String(localized: "pincode.validation.wrong")))
		} else if case .validation = mode {
			state.error = nil
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
				if case let .validation(lockout) = mode {
					
					// Do not show bio login on lockout.
					guard !lockout else { return }
					
					// Only show bio login when enabled
					guard Current.secureUserSettings.bioMetricAuthenticationEnabled else { return }
					
					delay(0.5) {
						self.showBioMetricLogin()
					}
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
			} else if case .validation = mode {
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
		
		if case let .validation(lockOut) = mode {
			self.coordinator?.handle(lockOut ? .pinCodeValidatedAfterLockout : .pinCodeValidated)
		}
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
				handleSuccessfulValidation()
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
	
	private func handleSuccessfulValidation() {
		
		logInfo("Pincode: User has been successfully validated")
		// Fill the boxes to display success
		accessCode = ["0", "0", "0", "0", "0"]
		// Navigate to the next scene after a short delay to let the faceID/touchID animation complete.
		delay(0.8) {
			switch self.mode {
				case .creation, .confirmation:
					break

				case .validation(let lockOut):
					if lockOut {
						self.coordinator?.handle(Coordination.Action.pinCodeValidatedAfterLockout)
					} else {
						self.coordinator?.handle(Coordination.Action.pinCodeValidated)
					}
			}
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
	
	/// Accessibility size category
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	
	@State private var scrollViewSize: CGSize = .zero
	
	/// Magic numbers
	private struct ViewTraits {
		enum ForgotButton {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Button {
			static let minimumHeight: CGFloat = 46
		}
		enum General {
			static let spacing: CGFloat = 6
			static let horizontalPadding: CGFloat = 16
			static let bottomPadding: CGFloat = 16
		}
		enum Box {
			static let spacing: CGFloat = 12
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum Heading {
			static let spacing: CGFloat = 16
			static let minHeight: CGFloat = 100
		}
		enum Feedback {
			static let spacing: CGFloat = 4
			static let minHeight: CGFloat = 25
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		VStack {
			ScrollView {
				pinCodeTopView()
					.when(dynamicTypeSize < DynamicTypeSize.xxLarge) { view in
					view
						.frame(height: scrollViewSize.height - (isiPhoneSE ? 50 : 0))
				}
			}
			.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18), customize: { view in
				view.bounces = false
			})
			.readSize($scrollViewSize)
			
			pincodeKeyboardView()
		}
		.padding(.horizontal, ViewTraits.General.horizontalPadding)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden(true)
		.when(viewModel.state.backButtonVisible) { view in
			// Show the back button
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
	
	/// The top half of the view
	/// - Returns: top view
	@ViewBuilder func pinCodeTopView() -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Heading.spacing) {
			
			headingView()
			
			Spacer()
			
			pincodeDisplayBoxes()
				
			feedbackView()
				.padding(.top, ViewTraits.Feedback.padding)
			
			Spacer()
			
			if viewModel.state.forgotCodeButtonVisible {
				Button(action: {
					viewModel.reduce(.forgotPinCode)
				}, label: {
					Text("pincode.forgot")
				})
				.buttonStyle(LinkButtonStyle(.center))
				.padding(ViewTraits.ForgotButton.insets)
				.accessibilityIdentifier("pincode.forgot")
			}
		}
	}
	
	/// Create the headers for the page
	/// - Returns: the header view
	@ViewBuilder func headingView() -> some View {
		
		VStack(alignment: .center, spacing: ViewTraits.Heading.spacing, content: {
			
			Text(viewModel.state.title)
				.rijksoverheidStyle(font: .bold, style: .title)
				.frame(maxWidth: .infinity, alignment: viewModel.state.textAlignment == .center ? .center : .leading)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier("pincode.heading")
			
			Text(viewModel.state.message)
				.rijksoverheidStyle(font: .regular, style: .body)
				.frame(maxWidth: .infinity, alignment: viewModel.state.textAlignment == .center ? .center : .leading)
				.multilineTextAlignment(viewModel.state.textAlignment)
		})
		.frame(minHeight: ViewTraits.Heading.minHeight, alignment: .top)
	}
	
	/// The boxes for the entered pinCode
	/// - Returns: box view
	@ViewBuilder func pincodeDisplayBoxes() -> some View {
		
		HStack(spacing: 0) {
			Spacer()
			HStack(spacing: ViewTraits.Box.spacing) {
				ForEach($viewModel.boxStates, id: \.self) { element in
					PinCodeBoxView(state: element.state)
						.accessibilityHidden(false)
						.accessibilityIdentifier("box \(element.id + 1)")
						.accessibilityLabel(element.wrappedValue.accessibilityLabel(index: element.id + 1, count: viewModel.boxStates.count))
				}
			}
			.padding(.horizontal, ViewTraits.General.horizontalPadding)
			Spacer()
		}
	}
	
	/// Show feedback to the user if the pincode is wrong, too weak etc.
	/// - Returns: feedback view
	@ViewBuilder func feedbackView() -> some View {
		
		HStack(spacing: ViewTraits.Feedback.spacing) {
			if let error = viewModel.state.error {
				Spacer()
				
				Image(ImageResource.Icon.error)
				
				Text(error)
					.rijksoverheidStyle(font: .bold, style: .body)
				
				Spacer()
			} else {
				Spacer()
			}
		}
		.foregroundStyle(theme.sentimentCritical)
		.frame(minHeight: ViewTraits.Feedback.minHeight, alignment: .top)
	}
	
	/// Build the keyboard
	/// - Returns: keyboard view
	@ViewBuilder func pincodeKeyboardView() -> some View {
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
				
				bioMetricButton()
				digitButton(for: "0")
				eraseButton()
			}
		}
		.when(safeAreaInsets.bottom == 0) { view in
			view.padding(.bottom, ViewTraits.General.bottomPadding)
		}
	}
	
	/// The button for biometric access
	/// - Returns: the biometric button
	@ViewBuilder func bioMetricButton() -> some View {
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
	}
	
	@ViewBuilder func eraseButton() -> some View {
		
		actionButton(
			for: .erasePressed,
			imageName: "delete.backward",
			accessibilityLabel: "pincode.erase.voiceover")
		
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
				mode: .validation(lockOut: false),
				bioMetricType: {
					.touchID // Preview as touch
				}
			)
		)
	}
}
