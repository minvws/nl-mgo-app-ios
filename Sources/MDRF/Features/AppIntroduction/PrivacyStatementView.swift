/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

struct PrivacyStatementView: View {
	
	/// Global dismiss closure
	@Environment(\.dismiss) var dismiss
	
	/// Magic Numbers
	private struct ViewTraits {
		enum CloseButton {
			static let insets = EdgeInsets( top: 14, leading: 0, bottom: 14, trailing: 14
			)
		}
		enum PrivacyStatement {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack(alignment: .leading, spacing: 0) {
				
				HStack {
					
					Spacer()
					
					Button(
						action: {
							dismiss()
						}, label: {
							Image(.close)
						}
					)
					.padding(ViewTraits.CloseButton.insets)
				}
				
				Group {
					
					Text("privacy_statement_title")
						.rijksoverheidStyle(font: .bold, style: .title2)
						.accessibilityAddTraits(.isHeader)
					
					ScrollView {
						Text("privacy_statement_body")
							.rijksoverheidStyle(font: .regular, style: .body)
					}
				}
				.foregroundColor(.blackText)
				.padding(ViewTraits.PrivacyStatement.insets)
				.fixedSize(horizontal: false, vertical: true)
				
				Spacer()
			}
		}
	}
}

#Preview {
	PrivacyStatementView()
}
