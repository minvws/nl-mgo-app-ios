/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A clear to background gradient
struct ClearToBackgroundGradientView: View {
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			
			LinearGradient(
				stops: [
					Gradient.Stop(color: .clear, location: 0.0),
					Gradient.Stop(color: Color.background, location: 1)
				],
				startPoint: .top,
				endPoint: .bottom
			)
			.frame(maxHeight: 50)
		}
	}
}

#Preview {
	ClearToBackgroundGradientView()
}
