/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

public class URLOpenerSpy: URLOpenerProtocol {

	public var invokedCanOpenURL = false
	public var invokedCanOpenURLCount = 0
	public var invokedCanOpenURLParameters: (url: URL, Void)?
	public var invokedCanOpenURLParametersList = [(url: URL, Void)]()
	public var stubbedCanOpenURLResult: Bool! = false

	public func canOpenURL(_ url: URL) -> Bool {
		invokedCanOpenURL = true
		invokedCanOpenURLCount += 1
		invokedCanOpenURLParameters = (url, ())
		invokedCanOpenURLParametersList.append((url, ()))
		return stubbedCanOpenURLResult
	}

	public var invokedOpen = false
	public var invokedOpenCount = 0
	public var invokedOpenParameters: (url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any])?
	public var invokedOpenParametersList = [(url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any])]()
	public var stubbedOpenCompletionResult: Bool! = false

	public func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool {
		invokedOpen = true
		invokedOpenCount += 1
		invokedOpenParameters = (url, options)
		invokedOpenParametersList.append((url, options))
		return stubbedOpenCompletionResult
	}
}
