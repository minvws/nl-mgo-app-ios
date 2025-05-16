/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SnapshotTesting

extension UITraitCollection {
	
	/// Get the UITraitCollection for an iPhone 16 Pro
	/// - Parameter orientation: the orientation of the device
	/// - Returns: UITraitCollection for an iPhone 16 Pro
	public static func iPhone16Pro(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection {
		let base: [UITraitCollection] = [
			.init(forceTouchCapability: .available),
			.init(layoutDirection: .leftToRight),
			.init(preferredContentSizeCategory: .medium),
			.init(userInterfaceIdiom: .phone)
		]
		switch orientation {
			case .landscape:
				return .init(
					traitsFrom: base + [
						.init(horizontalSizeClass: .compact),
						.init(verticalSizeClass: .compact)
					]
				)
			case .portrait:
				return .init(
					traitsFrom: base + [
						.init(horizontalSizeClass: .compact),
						.init(verticalSizeClass: .regular)
					]
				)
		}
	}
}
