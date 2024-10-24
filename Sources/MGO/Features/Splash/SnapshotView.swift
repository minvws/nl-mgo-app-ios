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
	
	@State private var rijkslintTopOffset: CGFloat = 0
	@State private var spinnerBottomPadding: CGFloat = 0
	
	private struct ViewTraits {
		enum DynamicIsland {
			static let height: CGFloat = 59
			static let offset: CGFloat = 11
		}
		enum Notch {
			static let height: CGFloat = 47
			static let offset: CGFloat = 16
		}
		enum Title {
			static let topOffset: CGFloat = 64
		}
		enum Spinner {
			static let bottomOffset: CGFloat = 75
		}
		enum Rijkslint {
			static let height: CGFloat = 100
			static let width: CGFloat = 50
		}
	}
	
	/// Calculate the offset for the rijkslint so it stays just below the notch or dynamic island
	/// - Parameter safeAreaHeight: the height of the safe area
	func recalculateOffset(_ safeAreaInsets: EdgeInsets) {
		if safeAreaInsets.top >= ViewTraits.DynamicIsland.height {
			rijkslintTopOffset = safeAreaInsets.top - ViewTraits.DynamicIsland.offset
		} else if safeAreaInsets.top >= ViewTraits.Notch.height {
			rijkslintTopOffset = safeAreaInsets.top - ViewTraits.Notch.offset
		} else {
			rijkslintTopOffset = 0
		}
	}
	
	private func recalculateBottomPadding(_ safeAreaInsets: EdgeInsets) {
		spinnerBottomPadding = 70 - safeAreaInsets.bottom
	}
	
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
