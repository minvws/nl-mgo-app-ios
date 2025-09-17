/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	enum Detent: Hashable {
		
		/// The system detent for a sheet that's approximately half the height of
		/// the screen, and is inactive in compact height.
		case medium
		
		/// The system detent for a sheet at full height.
		case large
		
		/// A custom detent with the specified fractional height.
		case fraction(_ fraction: CGFloat)
		
		/// A custom detent with the specified height.
		case height(_ height: CGFloat)
		
		@available(iOS 16.0, *)
		public func cast() -> PresentationDetent {
			switch self {
				case .medium:
					PresentationDetent.medium
				case .large:
					PresentationDetent.large
				case .fraction(let fraction):
					PresentationDetent.fraction(fraction)
				case .height(let height):
					PresentationDetent.height(height)
			}
		}
	}
	
	/// Back ported version of presentation detents
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationdetents(_:)
	/// - Parameters:
	///   - detents: Set of detents
	/// - Returns: view
	@MainActor @ViewBuilder func presentationDetents(
		_ detents: Set<Detent>
	) -> some View {
		if #available(iOS 16.0, *) {
			content
				.presentationDetents(Set(detents.map { $0.cast() }))
		} else {
			content
		}
	}
}
