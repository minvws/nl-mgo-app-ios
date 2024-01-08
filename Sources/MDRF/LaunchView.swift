/*
* Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SwiftUI

struct LaunchView: View {
	var body: some View {
		Image(systemName: "medical.thermometer")
			.resizable()
			.frame(width: 50, height: 50)
			.foregroundColor(.red)
		Text("launch_title")
			.font(.largeTitle)
			.fontWeight(.bold)
	}
}

#Preview {
	LaunchView()
}
