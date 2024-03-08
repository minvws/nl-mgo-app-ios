/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct AccessCodeViewState {
	
	enum MessageType {
		case regular
		case alert
	}
	
	var bioMetricEnabled: Bool = false
	var bioMetricType: LocalAuthentication.BiometricType = .none
	var eraseEnabled: Bool = false
	var backButtonEnabled: Bool = false
	var title: LocalizedStringKey
	var message: LocalizedStringKey
	var messageType: MessageType = .regular
}

class AccessCodeViewModel: ObservableObject {
	
	/// The various modes this scene can be run as.
	enum AccessCodeMode: Equatable {
		case creation // Create an access code
		case confirmation // Confirm that accces code
//		case validation // Validate the acces code (login)
	}
	/// A helper struct to make an enum (AccessCodeBoxView.State) identificable.
	struct AccessCodeBoxState: Identifiable, Hashable {
		
		var id: Int
		var state: AccessCodeBoxView.State
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case buttonPressed(value: String)
		case erasePressed
		case biometricKeyPressed
		case backButtonPressed
	}
	
	/// The mode of this view (creation, validation)
	private var mode: AccessCodeMode
	
	/// The number of digits for the access code
	private var numberOfDigits: Int = 5
	
	/// The state of the view
	@Published var state: AccessCodeViewState = AccessCodeViewState(title: "", message: "")
	
	/// Tha strenth validator for the access code
	private var strengthValidator: StrengthValidation = StrengthValidator()
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// The access code
	#warning("Todo: Accesscode must be private and unpublished.")
	@Published var accessCode: [String] = [] {
		didSet {
			for index in 0 ..< numberOfDigits {
				if accessCode.count < index {
					// A box that is yet to be filled
					boxStates[index].state = .empty
				} else if accessCode.count == index {
					// The box that is currently being filled
					boxStates[index].state = .focus
				} else if accessCode.count == index + 1 {
					// A box that is already filled.
					boxStates[index].state = oldValue.count < accessCode.count ? .filling : .filled
				} else if accessCode.count > index {
					// A box that is already filled.
					boxStates[index].state = .filled
				}
			}
			logDebug("\(boxStates)")
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
		bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		self.coordinator = coordinator
		self.mode = mode
		self.numberOfDigits = pinLimit
		self.state.bioMetricType = bioMetricType()

		updateState()
		for index in 0 ..< pinLimit {
			boxStates.append(AccessCodeBoxState(id: index, state: .empty))
		}
	}
	
	/// Update the state
	/// - Parameters:
	///   - tooWeak: setup for too weak access code
	///   - confirmationMismatch: setup for confirmation mismatched.
	private func updateState(tooWeak: Bool = false, confirmationMismatch: Bool = false) {
		
		state.bioMetricEnabled = false // to be changed with validation
		state.eraseEnabled = accessCode.isNotEmpty
		state.backButtonEnabled = self.mode == .confirmation
		if tooWeak {
			// Setup for access code is too weak
			state.title = "accesscode_create_title"
			state.message = "accesscode_tooweak_body"
			state.messageType = .alert
		} else if confirmationMismatch {
			// Setup for access codes do not match
			state.title = "accesscode_confirmation_title"
			state.message = "accesscode_mismatch_body"
			state.messageType = .alert
		} else if mode == .confirmation {
			// Setup for access code confirmation
			state.title = "accesscode_confirmation_title"
			state.message = "accesscode_confirmation_body"
			state.messageType = .regular
		} else {
			// Setup for regular access code entry
			state.title = "accesscode_create_title"
			state.message = "accesscode_create_body"
			state.messageType = .regular
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: Action) {
		switch action {
			case .buttonPressed(let value):
				buttonPressed(value)
			case .erasePressed:
				erasePressed()
			case .biometricKeyPressed:
				biometricKeyPressed()
			case .backButtonPressed:
				coordinator?.handle(AppCoordination.Action.backButtonPressed)
		}
	}
	
	/// The user pressed on the keyboard to enter a digit
	/// - Parameter value: the value of the digit
	private func buttonPressed(_ value: String) {
		
		if accessCode.count < numberOfDigits {
			accessCode.append(value)
			Haptic.light()
			updateState()
		}
		if accessCode.count == numberOfDigits {
			updateState()
			if mode == .creation {
				handleCreationCompletion()
			} else if mode == .confirmation {
				handleConfirmationCompletion()
			}
		}
	}
	
	/// All digits are entered. Check  for strength
	private func handleCreationCompletion() {
		
		let code = accessCode.joined()
		guard strengthValidator.validate(code) else {
			logDebug("accessCode too weak")
			
			// Show too weak message
			updateState(tooWeak: true)
			setErrorState()
			return
		}
		
		// All ok, store temp and move to confirmation
		Haptic.light()
		// Store temp accesscode
		logDebug("temp accessCode is \(code)")
		Current.secureUserSettings.tempAccessCode = code
		coordinator?.handle(.accessCodeEntered)
	}
	
	/// Confirmation entered, compare with the previous value
	private func handleConfirmationCompletion() {
		
		let code = accessCode.joined()
		guard code == Current.secureUserSettings.tempAccessCode else {
			// tempAccessCode and code do not match. Doh!
			updateState(confirmationMismatch: true)
			setErrorState()
			
			return
		}
		
		// All ok, store access code and get out of here.
		Haptic.light()
		Current.secureUserSettings.accessCode = code
		coordinator?.handle(.accessCodeConfirmed)
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
		}
		updateState()
	}
	
	/// The user pressed the face ID button
	private func biometricKeyPressed() {
		logDebug("biometricKey Pressed")
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
		enum Button {
			static let minimumHeight: CGFloat = 44
		}
		enum General {
			static let spacing: CGFloat = 8
			static let horizontalPadding: CGFloat = 16
		}
		enum Box {
			static let spacing: CGFloat = 12
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
					.if(viewModel.state.backButtonEnabled) { view in
							view.padding(ViewTraits.Title.insetsWithNavBar)
					}
					.if(!viewModel.state.backButtonEnabled) { view in
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
					}
				}
				
				Spacer()
				
				#warning("Todo: Remove this accessCode.")
//				HStack {
//					Spacer()
//					
//					Text(viewModel.accessCode.joined())
//						.rijksoverheidStyle(font: .bold, style: .largeTitle)
//					Spacer()
//				}
//				.frame(minHeight: 50)
//				.background(.orange)
				
				VStack(spacing: ViewTraits.General.spacing) {
					
					HStack(spacing: ViewTraits.Box.spacing) {
						ForEach($viewModel.boxStates, id: \.self) { element in
							AccessCodeBoxView(state: element.state)
						}
					}
					.padding(.bottom, 22)
					
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
							
							actionButton(for: .erasePressed, imageName: "delete.backward", accessibilityLabel: "accesscode_button_erase")
								.disabled(!viewModel.state.eraseEnabled)
							
						}
					}
				}
				.padding(.horizontal, ViewTraits.General.horizontalPadding) // For the whole keyboard
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.if(viewModel.state.backButtonEnabled) { view in
			view.navigationBarItems(leading: BackButton("general_previous") {
				viewModel.reduce(.backButtonPressed)
			})
		}
		.onAppear {
			if UIDevice.current.userInterfaceIdiom == .phone {
				OrientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
			}
		}
		.onDisappear {
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
				mode: .creation,
				bioMetricType: {
					.touchID // Preview as touch
				}
			)
		)
	}
}
