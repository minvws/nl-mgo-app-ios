/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Lottie
import SwiftUI

/// SwiftUI wrapper around `LottieView` that centralises the project's animation defaults.
///
/// Loads a local dotLottie (`.lottie`) animation from the given bundle. The wrapper claims
/// a usable size up-front via `aspectRatio`, so callers can place it inside a width-bound
/// container without supplying an explicit frame.
public struct MGOLottieView: View {

	private let name: String
	private let bundle: Bundle
	private let loopMode: LottieLoopMode
	private let aspectRatio: CGFloat

	/// Create a Lottie animation view.
	/// - Parameters:
	///   - name: name of the `.lottie` animation in the given bundle (without extension)
	///   - bundle: bundle that contains the animation; defaults to `.main` (the app target)
	///   - loopMode: loop behaviour, defaults to `.loop`
	///   - aspectRatio: width/height ratio applied synchronously so the view has a non-zero
	///     size before the animation finishes loading. Defaults to `1` (square).
	public init(
		_ name: String,
		bundle: Bundle = .main,
		loopMode: LottieLoopMode = .loop,
		aspectRatio: CGFloat = 1
	) {
		self.name = name
		self.bundle = bundle
		self.loopMode = loopMode
		self.aspectRatio = aspectRatio
	}

	public var body: some View {
		LottieView { try? await DotLottieFile.named(name, bundle: bundle) }
			.playing(loopMode: loopMode)
			.resizable()
			.aspectRatio(aspectRatio, contentMode: .fit)
	}
}
