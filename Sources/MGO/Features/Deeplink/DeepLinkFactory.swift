/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

public final class DeepLinkFactory {
	
	/// Create a deep link
	/// - Parameter url: incoming url
	/// - Returns: deep link
	public func create(_ url: URL) -> DeepLink? {
		
		guard url.scheme == Configuration().getCallbackScheme() else { return nil }
		
		if url.host == "app", url.path == "/login", let userinfo = url["userinfo"] {
			return DeepLink.digidCallback(userinfo: userinfo)
		}
		return nil
	}
}
