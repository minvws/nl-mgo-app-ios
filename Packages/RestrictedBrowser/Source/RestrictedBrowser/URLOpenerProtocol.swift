/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		
		if canOpenURL(url) {
			_Concurrency.Task { @MainActor in
				_ = await open(url, options: [:])
			}
		}
	}
}

// MARK: - UIApplication
extension UIApplication: URLOpenerProtocol { }
