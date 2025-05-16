/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public protocol URLOpenerProtocol {

	/// Can we open this url
	///
	/// - Parameter url: the url to open
	/// - Returns: True if we can open the url
	func canOpenURL(_ url: URL) -> Bool

	/// Open the url
	/// 
	/// - Parameters:
	///   - url: the url to open
	///   - options: the options
	/// - Returns: True if the url is opened
	func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
}

extension URLOpenerProtocol {
	
	public func openUrlIfPossible(_ url: URL) {
		
		if self is UIApplication {
			// does not always work when used as protocol.
			if UIApplication.shared.canOpenURL(url) {
				_Concurrency.Task { @MainActor in
					_ = await UIApplication.shared.open(url, options: [:])
				}
			}
		} else if canOpenURL(url) {
			_Concurrency.Task { @MainActor in
				_ = await open(url, options: [:])
			}
		}
	}
}

// MARK: - UIApplication
extension UIApplication: URLOpenerProtocol { }
