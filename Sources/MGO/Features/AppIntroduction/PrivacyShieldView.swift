/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import MGOUI

/// A view containing a privacy shield and a text (as localizesStringKey)
struct PrivacyShieldView: View {

	/// Magic Numbers
	private struct ViewTraits {
		enum Text {
			static let insets = EdgeInsets(
				top: 0,
				leading: 16,
				bottom: 16,
				trailing: 0
			)
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey) {
		self.title = title
	}
	
	var body: some View {
		
		HStack(alignment: .top, spacing: 0) {
			
			Image(.shield)
				.padding(.zero)
			
			Text(title)
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(ViewTraits.Text.insets)
				.foregroundColor(.blackText)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
	}
}

#Preview {
	PrivacyShieldView("privacy_item_1")
}
