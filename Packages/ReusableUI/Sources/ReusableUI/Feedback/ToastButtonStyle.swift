/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

struct ToastButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Style the button to a back button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.opacity(configuration.isPressed ? 0.5 : 1)
	}
}
