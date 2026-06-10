/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SnapshotTesting
import SwiftUI
import XCTest

/// Wraps a non-Sendable value so it can be passed into a @MainActor context
/// via MainActor.assumeIsolated. Safe to use only when you are already on the
/// main thread (e.g., in XCTest snapshot helpers).
private struct SendableBox<T>: @unchecked Sendable {
	let value: T
}

extension XCTestCase {
	
	/// Take a snapshot of this content in light and dark Mode, in landscape and portrait.
	/// - Parameters:
	///   - content: the view for the snapshots
	///   - name: The name of the test
	///   - precision: the precision to check against (default 1.0 = exact pixel match)
	///   - perceptualPrecision: perceptual color-difference tolerance (default 0.95); absorbs
	///     sub-pixel text anti-aliasing differences across simulator versions without hiding real
	///     regressions. A snapshot passes if it satisfies either precision or perceptualPrecision.
	///   - file: the file
	///   - isRecording: true if we should record new snapshots
	public func takeSnapShots(
		content: some View,
		name: String = #function,
		precision: Float = 1.0,
		perceptualPrecision: Float = 0.95,
		file: StaticString = #filePath,
		isRecording: Bool = false
	) {
		
		// Dark Mode & Portrait orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.dark)),
			as: .image(
				on: .iPhone17Pro(.portrait),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_darkPortrait",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Light Mode & Portrait orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.light)),
			as: .image(
				on: .iPhone17Pro(.portrait),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_lightPortrait",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Dark Mode & Landscape orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.dark)),
			as: .image(
				on: .iPhone17Pro(.landscape),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_darkLandscape",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Light Mode & Landscape orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.light)),
			as: .image(
				on: .iPhone17Pro(.landscape),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_lightLandscape",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
	}
	
	/// Take a snapshot of this content in light and dark Mode, in landscape and portrait.
	/// - Parameters:
	///   - content: the view for the snapshots
	///   - name: The name of the test
	///   - precision: the precision to check against (default 1.0 = exact pixel match)
	///   - perceptualPrecision: perceptual color-difference tolerance (default 0.95)
	///   - file: the file
	///   - isRecording: true if we should record new snapshots
	public func takeSnapShotsForiPad(
		content: some View,
		name: String = #function,
		precision: Float = 1.0,
		perceptualPrecision: Float = 0.95,
		file: StaticString = #filePath,
		isRecording: Bool = false
	) {
		
		// Dark Mode & Portrait orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.dark)),
			as: .image(
				on: .iPadPro11(.portrait),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_iPad_darkPortrait",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Light Mode & Portrait orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.light)),
			as: .image(
				on: .iPadPro11(.portrait),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_iPad_lightPortrait",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Dark Mode & Landscape orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.dark)),
			as: .image(
				on: .iPadPro11(.landscape),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_iPad_darkLandscape",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
		
		// Light Mode & Landscape orientation
		assertSnapshot(
			of: preparedHostingController(rootView: content.colorScheme(.light)),
			as: .image(
				on: .iPadPro11(.landscape),
				precision: precision,
				perceptualPrecision: perceptualPrecision
			),
			named: "_iPad_lightLandscape",
			record: isRecording ? .all : nil,
			file: file,
			testName: name
		)
	}
	
	/// Creates a UIHostingController and prepares it for snapshotting by:
	/// 1. Draining the RunLoop so any lingering SnapshotTesting rendering window from the
	///    previous assertSnapshot call (even from a prior test) has its dispose() closure
	///    executed and is removed from the CALayer tree before we begin.
	/// 2. Embedding the controller in a UINavigationController (with hidden nav bar and
	///    toolbar) so that SwiftUI toolbar items — including iOS 26's UIKitToolbar used for
	///    .bottomBar placement — have a proper UIKit view hierarchy to attach to. Without
	///    this, UIKit falls back to adding UIKitToolbar as a subview of
	///    UIHostingController.view, which is unsupported and triggers a runtime warning.
	/// 3. Embedding the navigation controller in a UIWindow placed far off-screen
	///    (y: -height*2) so its CALayer content falls outside the bounds that
	///    SnapshotTesting's layer.render(in:) captures, while still allowing onAppear /
	///    onGeometryChange / geometry callbacks to fire normally.
	/// 4. Running the RunLoop a second time so State updates and re-layouts triggered by
	///    those callbacks settle before the snapshot is taken.
	/// 5. Hiding the prep window before returning so it is not composited into
	///    SnapshotTesting's own rendering window.
	private func preparedHostingController<V: View>(rootView: V) -> UIHostingController<V> {
		// Wrap in @unchecked Sendable so we can safely pass the view value into the
		// @MainActor assumeIsolated closure without triggering SE-0414 region isolation
		// errors. This is safe because tests always run on the main thread, so there
		// is no concurrent access to rootView.
		let box = SendableBox(value: rootView)
		return MainActor.assumeIsolated {
			// Drain the RunLoop before creating the new prep window so that any
			// lingering SnapshotTesting rendering windows from the previous
			// assertSnapshot call (including from the previous test) have had their
			// dispose() closures execute and been removed from the layer tree.
			RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
			
			let controller = UIHostingController(rootView: box.value)
			let size = UIScreen.main.bounds.size
			// Place the window far off-screen so its CALayer is outside the visible
			// region that SnapshotTesting's layer.render(in:) composites. The window
			// still participates in the layer tree (allowing onAppear / geometry
			// callbacks to fire) but its content is outside the render bounds.
			let offscreenOrigin = CGPoint(x: 0, y: -size.height * 2)
			let window = UIWindow(frame: CGRect(origin: offscreenOrigin, size: size))
			// Embed in a UINavigationController so toolbar infrastructure (including
			// iOS 26's UIKitToolbar for .bottomBar placement) has a proper container
			// in the view hierarchy. The nav bar and toolbar are hidden so they don't
			// affect snapshot output.
			let navigationController = UINavigationController(rootViewController: controller)
			navigationController.setNavigationBarHidden(true, animated: false)
			navigationController.setToolbarHidden(true, animated: false)
			window.rootViewController = navigationController
			window.isHidden = false
			controller.view.setNeedsLayout()
			controller.view.layoutIfNeeded()
			RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
			window.isHidden = true
			return controller
		}
	}
}
