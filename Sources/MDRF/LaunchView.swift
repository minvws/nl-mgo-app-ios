/*
* Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SwiftUI

struct LaunchView: View {
	var body: some View {
		ZStack {
			Color.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			VStack {
				Image(ImageResource.rijkslint)
					.ignoresSafeArea()
				Text("launch_title")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(Color.splashTitle)
				Spacer()
			}
		}
	}
}

#Preview {
	LaunchView()
}
