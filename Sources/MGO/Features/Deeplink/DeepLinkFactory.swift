/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

public final class DeepLinkFactory {
	
	/// Create a deep link
	/// - Parameter url: incoming url
	/// - Returns: deep link
	public func create(_ url: URL) -> DeepLink? {
		
		guard url.scheme == Configuration().getCallbackScheme() else { return nil }
		
		if url.host == "app", url.path == "/login" {
			if let userinfo = url["userinfo"] {
				return DeepLink.digidCallback(userinfo: userinfo)
			}
		}
		return nil
	}
}
