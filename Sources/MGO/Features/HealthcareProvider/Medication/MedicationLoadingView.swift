/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct MedicationLoadingView: View {

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	/// Progress for the spinner
	@State private var progress: Double = 0

	var body: some View {
		
		VStack {
			
			HStack {
				Spacer()
				
				CircularProgressView(progress: $progress)
					.frame(width: 48, height: 48)
					.padding(.bottom, 20)
				
				Spacer()
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
		.onAppear(perform: {
			progress = 1
		})
	}
}

#Preview {
	NavigationView {
		MedicationLoadingView()
	}
}
