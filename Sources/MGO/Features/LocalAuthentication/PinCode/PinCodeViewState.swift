/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// An object to encapsulate the state of the view for access code
struct PinCodeViewState: Equatable {
	
	/// Is the biometric key (face ID, touch ID) enabled?
	var bioMetricEnabled: Bool = false
	
	/// What kind of key should we  display (face ID, touch ID, optic ID)
	var bioMetricType: LocalAuthentication.BiometricType = .none
	
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
	
	/// The key for the error
	var error: LocalizedStringKey?
	
	/// How should the title and text be aligned?
	var textAlignment: TextAlignment = .leading
	
	/// Should we show the popup when biometric access is locked out?
	var showLockoutPopup: Bool = false
}
