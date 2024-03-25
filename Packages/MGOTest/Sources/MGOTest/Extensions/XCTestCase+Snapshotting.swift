/*
*  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SnapshotTesting
import SwiftUI
import XCTest

extension XCTestCase {
	// Uncomment to enable global snapshot re-recording:
//	open override func setUp() {
//		super.setUp()
//		isRecording = true
//	}
}

extension XCTestCase {
	
	/// Take a snapshot of this content in light and dark Mode, in landscape and portrait.
	/// - Parameters:
	///   - content: the view for the snapshots
	///   - name: The name of the test
	public func takeSnapShots(content: some View, name: String) {
		
		// Dark Mode
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image,
			named: "_darkPortrait",
			testName: name
		)
		
		// Light Mode
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image,
			named: "_lightPortrait",
			testName: name
		)
		
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone15Pro(.landscape)),
			named: "_darkLandscape",
			testName: name
		)
		
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone15Pro(.landscape)),
			named: "_lightLandscape",
			testName: name
		)
	}
}
