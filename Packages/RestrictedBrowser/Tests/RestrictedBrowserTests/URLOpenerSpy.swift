/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RestrictedBrowser

class URLOpenerSpy: URLOpenerProtocol {

	var invokedCanOpenURL = false
	var invokedCanOpenURLCount = 0
	var invokedCanOpenURLParameters: (url: URL, Void)?
	var invokedCanOpenURLParametersList = [(url: URL, Void)]()
	var stubbedCanOpenURLResult: Bool! = false

	func canOpenURL(_ url: URL) -> Bool {
		invokedCanOpenURL = true
		invokedCanOpenURLCount += 1
		invokedCanOpenURLParameters = (url, ())
		invokedCanOpenURLParametersList.append((url, ()))
		return stubbedCanOpenURLResult
	}

	var invokedOpen = false
	var invokedOpenCount = 0
	var invokedOpenParameters: (url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any])?
	var invokedOpenParametersList = [(url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any])]()
	var stubbedOpenCompletionResult: (Bool, Void)?

	func open(
		_ url: URL,
		options: [UIApplication.OpenExternalURLOptionsKey: Any],
		completionHandler completion: ((Bool) -> Swift.Void)?) {
		invokedOpen = true
		invokedOpenCount += 1
		invokedOpenParameters = (url, options)
		invokedOpenParametersList.append((url, options))
		if let result = stubbedOpenCompletionResult {
			_ = completion?(result.0)
		}
	}
}
