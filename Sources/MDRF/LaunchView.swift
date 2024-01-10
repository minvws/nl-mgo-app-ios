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
		
		static let dynamicIslandHeight: CGFloat = 59
		static let dynamicIslandOffset: CGFloat = 11
		static let notchHeight: CGFloat = 47
		static let notchOffset: CGFloat = 13
		
		enum Title {
			static let topOffset: CGFloat = 64
		}
	}
	
	func recalculateOffset(safeAreaHeight: CGFloat) {
		if safeAreaHeight >= ViewTraits.dynamicIslandHeight {
			rijkslintTopOffset = safeAreaHeight - ViewTraits.dynamicIslandOffset
		} else if safeAreaHeight >= ViewTraits.notchHeight {
			rijkslintTopOffset = safeAreaHeight - ViewTraits.notchOffset
		}
		print("Safe area height: \(safeAreaHeight) -> \(rijkslintTopOffset)")
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
				//	.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
				//	recalculateOffset(safeAreaHeight: geometry.safeAreaInsets.top)
				//	}
			}
		}
	}
}

#Preview {
	LaunchView()
}
