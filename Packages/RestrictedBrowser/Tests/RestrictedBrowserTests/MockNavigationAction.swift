/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import WebKit

final class MockNavigationAction: WKNavigationAction {
	let urlRequest: URLRequest
	
	var receivedPolicy: WKNavigationActionPolicy?
	
	override var request: URLRequest { urlRequest }

	init(urlRequest: URLRequest) {
		self.urlRequest = urlRequest
		super.init()
	}
	
	convenience init(url: URL) {
		self.init(urlRequest: URLRequest(url: url))
	}
	
	func decisionHandler(_ policy: WKNavigationActionPolicy) { self.receivedPolicy = policy }
}
