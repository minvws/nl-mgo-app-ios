/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SnapshotTesting

extension ViewImageConfig {
	
	/// Get view image configuration for a iPhone 16 Pro
	/// - Parameter orientation: the orientation (landscape, portrait)
	/// - Returns: view image configuration
	public static func iPhone16Pro(_ orientation: Orientation) -> ViewImageConfig {
	  let safeArea: UIEdgeInsets
	  let size: CGSize
	  switch orientation {
		  case .landscape:
			safeArea = .init(top: 0, left: 62, bottom: 21, right: 62)
			size = .init(width: 874, height: 402)
		  case .portrait:
			safeArea = .init(top: 62, left: 0, bottom: 34, right: 0)
			size = .init(width: 402, height: 874)
		}

	  return .init(
		safeArea: safeArea, size: size, traits: UITraitCollection.iPhone16Pro(orientation))
	}
}
