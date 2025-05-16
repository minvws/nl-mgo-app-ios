/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import SnapshotTesting
import MGOUI
import XCTest

extension XCTestCase {
	
	/// Take a snapshot of this content in light and dark Mode, in landscape and portrait.
	/// - Parameters:
	///   - content: the view for the snapshots
	///   - name: The name of the test
	///   - precision: the precision to check against (0.99 means 1% pixel difference)
	///   - file: the file
	///   - isRecording: true if we should record new snapshots
	public func takeSnapShots(
		content: some View,
		name: String = #function,
		precision: Float = 1.0,
		file: StaticString = #file,
		isRecording: Bool = false) {
		
		// Dark Mode & Portrait orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone16Pro(.portrait), precision: precision),
			named: "_darkPortrait",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Light Mode & Portrait orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone16Pro(.portrait), precision: precision),
			named: "_lightPortrait",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Dark Mode & Landscape orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone16Pro(.landscape), precision: precision),
			named: "_darkLandscape",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Light Mode & Landscape orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone16Pro(.landscape), precision: precision),
			named: "_lightLandscape",
			record: isRecording,
			file: file,
			testName: name
		)
	}
	
	/// Take a snapshot of this content in light and dark Mode, in landscape and portrait.
	/// - Parameters:
	///   - content: the view for the snapshots
	///   - name: The name of the test
	///   - precision: the precision to check against (0.99 means 1% pixel difference)
	///   - file: the file
	///   - isRecording: true if we should record new snapshots
	public func takeSnapShotsForiPad(
		content: some View,
		name: String = #function,
		precision: Float = 1.0,
		file: StaticString = #file,
		isRecording: Bool = false) {
		
		// Dark Mode & Portrait orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPadPro11(.portrait), precision: precision),
			named: "_iPad_darkPortrait",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Light Mode & Portrait orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPadPro11(.portrait), precision: precision),
			named: "_iPad_lightPortrait",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Dark Mode & Landscape orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPadPro11(.landscape), precision: precision),
			named: "_iPad_darkLandscape",
			record: isRecording,
			file: file,
			testName: name
		)
		
		// Light Mode & Landscape orientation
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPadPro11(.landscape), precision: precision),
			named: "_iPad_lightLandscape",
			record: isRecording,
			file: file,
			testName: name
		)
	}
}
