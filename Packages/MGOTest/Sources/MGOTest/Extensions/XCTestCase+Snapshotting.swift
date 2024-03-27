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
	///   - precision: the precision to check against (0.99 means 1% pixel difference)
	///   - file: the file
	public func takeSnapShots(content: some View, name: String = #function, precision: Float = 1.0, file: StaticString = #file) {
		
		// Dark Mode
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone15Pro(.portrait), precision: precision),
			named: "_darkPortrait",
			file: file,
			testName: name
		)
		
		// Light Mode
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone15Pro(.portrait), precision: precision),
			named: "_lightPortrait",
			file: file,
			testName: name
		)
		
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone15Pro(.landscape), precision: precision),
			named: "_darkLandscape",
			file: file,
			testName: name
		)
		
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone15Pro(.landscape), precision: precision),
			named: "_lightLandscape",
			file: file,
			testName: name
		)
	}
}
