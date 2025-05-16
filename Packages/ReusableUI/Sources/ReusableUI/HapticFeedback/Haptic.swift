/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

final public class Haptic {
	
	/// Give  a light haptic feedback
	public static func light() {
		
		let ifg = UIImpactFeedbackGenerator(style: .light)
		ifg.prepare()
		ifg.impactOccurred()
	}
	
	/// Give  a medium haptic feedback
	public static func medium() {

		let ifg = UIImpactFeedbackGenerator(style: .medium)
		ifg.prepare()
		ifg.impactOccurred()
	}

	/// Give  a heavy haptic feedback
	public static func heavy() {

		let ifg = UIImpactFeedbackGenerator(style: .heavy)
		ifg.prepare()
		ifg.impactOccurred()
	}
}
