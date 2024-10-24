/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct SnapshotView: View {
	
	@Binding var showSpinner: Bool
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				
				theme.backgroundPrimary
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				Image(ImageResource.splashLogo)
					.accessibilityLabel("common.app_name")
				
				if showSpinner {
					VStack {
						Spacer()
						ProgressView("common.loading")
//							.tint(theme.actionPrimaryDefaultBackground)
							.rijksoverheidStyle(font: .regular, style: .body)
							.foregroundStyle(theme.contentPrimary)
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
