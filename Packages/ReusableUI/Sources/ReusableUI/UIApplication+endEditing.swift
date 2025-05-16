/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public protocol EndEditing {
	func endEditing()
}

// See https://stackoverflow.com/a/56496669/443270
extension UIApplication: EndEditing {
	
	/// End editing, resign first responder
	public func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
