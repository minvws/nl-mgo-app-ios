/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SnapshotTesting
import SwiftUI

/// Creates a `UIHostingController` prepared for snapshotting.
///
/// Free-function counterpart to `XCTestCase.preparedHostingController`, intended for use
/// in Swift Testing suites that cannot call instance methods on `XCTestCase`.
///
/// The preparation steps mirror the XCTestCase version:
/// 1. Drain the RunLoop (50 ms) so any lingering SnapshotTesting rendering windows from a
///    previous assertion are disposed before the new one is created.
/// 2. Embed the controller in a `UIWindow` placed far off-screen so `CALayer` content falls
///    outside the render bounds captured by SnapshotTesting, while still allowing `onAppear`
///    and geometry callbacks to fire normally.
/// 3. Drain the RunLoop a second time so layout and state updates triggered by those
///    callbacks settle before the snapshot is taken.
/// 4. Hide the preparation window so it is not composited into SnapshotTesting's own window.
///
/// - Parameter rootView: The SwiftUI view to host.
/// - Returns: A laid-out `UIHostingController` ready to be passed to `assertSnapshot`.
@MainActor
func makeSnapshotHostingController<V: View>(rootView: V) -> UIHostingController<V> {
	RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
	let controller = UIHostingController(rootView: rootView)
	let size = UIScreen.main.bounds.size
	let offscreenOrigin = CGPoint(x: 0, y: -size.height * 2)
	let window = UIWindow(frame: CGRect(origin: offscreenOrigin, size: size))
	window.rootViewController = controller
	window.isHidden = false
	controller.view.setNeedsLayout()
	controller.view.layoutIfNeeded()
	RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
	window.isHidden = true
	return controller
}

/// Asserts snapshots in all four mode/orientation combinations (dark/light × portrait/landscape).
///
/// This is the free-function counterpart to `XCTestCase.takeSnapShots(_:)`, intended for use in
/// Swift Testing suites. Both call `assertSnapshot` from SnapshotTesting, which supports both
/// XCTest and Swift Testing and stores reference images under `__Snapshots__/<TestSuiteName>/`.
///
/// - Parameters:
///   - content: The SwiftUI view to snapshot.
///   - name: The base name used for the snapshot files. Defaults to the calling function name,
///     which SnapshotTesting sanitises and uses as the file stem.
///   - precision: Pixel-match tolerance in the range `0...1` (default `1.0` = exact match).
///     Use a value slightly below `1.0` (e.g. `0.99`) to absorb sub-pixel GPU rendering variance
///     across test-suite runs.
///   - file: Source file path, forwarded to SnapshotTesting for locating the `__Snapshots__`
///     directory relative to the test file.
///   - isRecording: When `true`, writes new reference images instead of asserting against them.
@MainActor
public func takeSnapShots(
	content: some View,
	name: String = #function,
	precision: Float = 1.0,
	file: StaticString = #filePath,
	isRecording: Bool = false
) {
	assertSnapshot(
		of: makeSnapshotHostingController(rootView: content.colorScheme(.dark)),
		as: .image(on: .iPhone17Pro(.portrait), precision: precision),
		named: "_darkPortrait",
		record: isRecording ? .all : nil,
		file: file,
		testName: name
	)
	assertSnapshot(
		of: makeSnapshotHostingController(rootView: content.colorScheme(.light)),
		as: .image(on: .iPhone17Pro(.portrait), precision: precision),
		named: "_lightPortrait",
		record: isRecording ? .all : nil,
		file: file,
		testName: name
	)
	assertSnapshot(
		of: makeSnapshotHostingController(rootView: content.colorScheme(.dark)),
		as: .image(on: .iPhone17Pro(.landscape), precision: precision),
		named: "_darkLandscape",
		record: isRecording ? .all : nil,
		file: file,
		testName: name
	)
	assertSnapshot(
		of: makeSnapshotHostingController(rootView: content.colorScheme(.light)),
		as: .image(on: .iPhone17Pro(.landscape), precision: precision),
		named: "_lightLandscape",
		record: isRecording ? .all : nil,
		file: file,
		testName: name
	)
}
