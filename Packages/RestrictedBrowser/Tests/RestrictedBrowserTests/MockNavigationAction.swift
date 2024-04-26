/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
