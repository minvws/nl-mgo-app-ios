/*
* Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SwiftUI

struct LaunchView: View {
	
	@State var rijkslintTopOffset: CGFloat = 0
	
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
	func recalculateOffset(safeAreaHeight: CGFloat) {
		if safeAreaHeight >= ViewTraits.DynamicIsland.height {
			rijkslintTopOffset = safeAreaHeight - ViewTraits.DynamicIsland.offset
		} else if safeAreaHeight >= ViewTraits.Notch.height {
			rijkslintTopOffset = safeAreaHeight - ViewTraits.Notch.offset
		} else {
			rijkslintTopOffset = 0
		}
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
						.font(.largeTitle)
						.fontWeight(.bold)
						.foregroundColor(Color.splashTitle)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
					Spacer()
				}
				.onAppear {
					recalculateOffset(safeAreaHeight: geometry.safeAreaInsets.top)
				}
				.onChange(of: geometry.safeAreaInsets.top) { newTop in
					recalculateOffset(safeAreaHeight: newTop)
				}
			}
		}
	}
}

#Preview {
	LaunchView()
}
