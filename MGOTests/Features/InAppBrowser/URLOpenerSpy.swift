/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest
import Nimble
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
	var stubbedOpenCompletionResult: Bool! = false

	func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool {
		invokedOpen = true
		invokedOpenCount += 1
		invokedOpenParameters = (url, options)
		invokedOpenParametersList.append((url, options))
		return stubbedOpenCompletionResult
	}
}
