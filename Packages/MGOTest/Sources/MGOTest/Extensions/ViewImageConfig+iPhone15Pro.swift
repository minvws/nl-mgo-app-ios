/*
*  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SnapshotTesting

extension ViewImageConfig {
	
	/// Get view image configuration for a iPhone 15 Pro
	/// - Parameter orientation: the orientation (landscape, portrait)
	/// - Returns: view image configuration
	public static func iPhone15Pro(_ orientation: Orientation) -> ViewImageConfig {
	  let safeArea: UIEdgeInsets
	  let size: CGSize
	  switch orientation {
		  case .landscape:
			safeArea = .init(top: 0, left: 59, bottom: 21, right: 59)
			size = .init(width: 852, height: 393)
		  case .portrait:
			safeArea = .init(top: 59, left: 0, bottom: 34, right: 0)
			size = .init(width: 393, height: 852)
		}

	  return .init(
		safeArea: safeArea, size: size, traits: UITraitCollection.iPhone15Pro(orientation))
	}
}
