/*
* Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SwiftUI
import GifzUI

struct DashboardView: View {
	
	var body: some View {
		ZStack {
			
			Color.background
				.ignoresSafeArea()
			
			VStack {
				
				Text("app_title")
					.rijksoverheidStyle(font: .bold, style: .largeTitle)
			 
				Text(verbatim: "That's all folks!")
				.rijksoverheidStyle(font: .regular, style: .body)
			}
		}
		.navigationBarBackButtonHidden()
	}
}

#Preview {
	DashboardView()
}
