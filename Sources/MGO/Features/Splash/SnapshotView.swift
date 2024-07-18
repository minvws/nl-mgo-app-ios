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
					.ignoresSafeArea()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				VStack {
					Image(ImageResource.rijkslint)
						.resizable()
						.frame(width: ViewTraits.Rijkslint.width, height: ViewTraits.Rijkslint.height)
						.padding(.top, rijkslintTopOffset)
						.ignoresSafeArea()
						.accessibilityLabel("launch.image.voiceover")
					
					Text("common.app_name")
						.rijksoverheidStyle(font: .bold, style: .largeTitle)
						.foregroundStyle(theme.contentPrimary)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
						.accessibilityAddTraits(.isHeader)
						.multilineTextAlignment(.center)
						.tag("common.app_name")
						.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
					if showSpinner {
						ProgressView("common.loading")
							.tint(theme.actionPrimaryBackground)
							.rijksoverheidStyle(font: .regular, style: .body)
							.foregroundStyle(theme.contentPrimary)
							.padding(.bottom, ViewTraits.Spinner.bottomOffset - geometry.safeAreaInsets.bottom)
					}
				}
				.onAppear {
					recalculateOffset(geometry.safeAreaInsets)
					recalculateBottomPadding(geometry.safeAreaInsets)
				}
				.onChange(of: geometry.safeAreaInsets) { insets in
					recalculateOffset(insets)
					recalculateBottomPadding(insets)
				}
			}
		}
	}
}

#Preview {
	SnapshotView(showSpinner: .constant(true))
}
