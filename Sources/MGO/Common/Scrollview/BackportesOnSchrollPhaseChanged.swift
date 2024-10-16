/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

public struct BackportedOnSchrollPhaseChanged: ViewModifier {
	
	@Binding var isScrolling: Bool

	public func body(content: Content) -> some View {
		if #available(iOS 18.0, *) {
			content
				.onScrollPhaseChange { oldPhase, newPhase in
					isScrolling = newPhase.isScrolling
				}
		} else {
			content
		}
	}
}

extension View {
	
	public func backportOnScrollPhaseChanged(_ isScrolling: Binding<Bool>) -> some View {
		
		modifier(BackportedOnSchrollPhaseChanged(isScrolling: isScrolling))
	}
}
