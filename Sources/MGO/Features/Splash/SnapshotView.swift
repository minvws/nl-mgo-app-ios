/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct SnapshotView: View {
	
	@Binding var showSpinner: Bool
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 6
			static let opacity: CGFloat = 0.6
		}
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				
				theme.backgroundPrimary
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				Image(ImageResource.splashLogo)
					.accessibilityLabel("common.app_name")
					.accessibilityIdentifier("common.app_name")
				
				if showSpinner {
					VStack {
						
						Spacer()
						
						HStack(spacing: ViewTraits.General.spacing) {
							
							Spacer()
							
							ProgressView()
								.tint(theme.contentPrimary.opacity(ViewTraits.General.opacity))
								.accessibilityHidden(true)
							
							Text("common.loading")
								.foregroundStyle(theme.contentPrimary.opacity(ViewTraits.General.opacity))
								.rijksoverheidStyle(font: .regular, style: .body)
							
							Spacer()
						}
						.offset(y: -geometry.size.height / 4)
					}
				}
			}
		}
		.navigationBarHidden(true)
		.ignoresSafeArea()
	}
}

#Preview {
	SnapshotView(showSpinner: .constant(true))
}
