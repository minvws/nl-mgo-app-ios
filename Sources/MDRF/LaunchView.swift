/*
* Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import GifzUI

struct LaunchView: View {
	
	@State var rijkslintTopOffset: CGFloat = 0
	@State var spinnerBottomPadding: CGFloat = 0
	
	private struct ViewTraits {
		enum DynamicIsland {
			static let height: CGFloat = 59
			static let offset: CGFloat = 11
		}
		enum Notch {
			static let height: CGFloat = 47
			static let offset: CGFloat = 13
		}
		enum Title {
			static let topOffset: CGFloat = 64
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
				Color.background
					.ignoresSafeArea()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				VStack {
					Image(ImageResource.rijkslint)
						.padding(.top, rijkslintTopOffset)
						.ignoresSafeArea()
					
					Text("launch_title")
						.rijksoverheidStyle(font: .bold, style: .largeTitle)
						.foregroundColor(Color.splashTitle)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
					Spacer()
					ProgressView("launch_loading")
						.tint(.black)
						.rijksoverheidStyle(font: .regular, style: .footnote)
						.foregroundColor(.black)
						.padding(.bottom, 70 - geometry.safeAreaInsets.bottom)
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
	LaunchView()
}
