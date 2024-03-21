/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct LinkButtonStyle: ButtonStyle {
	
	/// Is the button enabled?
	@Environment(\.isEnabled) private var isEnabled: Bool

	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundStyle(configuration.isPressed ? Color.Styleguide.Blue.linkHover : Color.Styleguide.Blue.link)
	}
}
