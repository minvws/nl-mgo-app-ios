/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

// See https://stackoverflow.com/a/41811798/443270
struct OrientationUtility {

	static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

		AppDelegate.orientationLock = orientation
	}
	
	static func unlockOrientation() {
		AppDelegate.orientationLock = .all
	}

	/// Lock the orientation and rotate
	/// - Parameters:
	///   - orientation: the orientation mask to lock to
	///   - rotateOrientation: the orientation to rotate to
	static func lockOrientation(
		_ orientation: UIInterfaceOrientationMask,
		andRotateTo rotateOrientation: UIInterfaceOrientation) {

		self.lockOrientation(orientation)
			
		if #available(iOS 16.0, *) {
			UIViewController.attemptRotationToDeviceOrientation()
			
			let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
			switch rotateOrientation {
				case .unknown:
					break
				case .portrait:
					windowScene?.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait ))
				case .portraitUpsideDown:
					windowScene?.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portraitUpsideDown ))
				case .landscapeLeft:
					windowScene?.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeLeft ))
				case .landscapeRight:
					windowScene?.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight ))
				@unknown default:
					break
			}
		} else {
			UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
			UINavigationController.attemptRotationToDeviceOrientation()
		}
	}
}
