/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
@testable import MGO

public class RemoteAuthenticationClientSpy: RemoteAuthenticationClientProtocol {

	required public init(serverUrl: Foundation.URL, username: String?, password: String?) {
		// Empty Init, needed for public access
	}

	private let queue = DispatchQueue(label: "com.RemoteAuthenticationClientSpy.serialqueue.\(UUID().uuidString)")
	
	public var invokedGetAuthenticationUrl = false
	public var invokedGetAuthenticationUrlCount = 0
	public var invokedGetAuthenticationUrlParameters: (callbackUrl: String, Void)?
	public var invokedGetAuthenticationUrlParametersList = [(callbackUrl: String, Void)]()
	public var stubbedGetAuthenticationUrl: URL!
	public var stubbedGetAuthenticationError: Error?
	
	public func getAuthenticationUrl(callbackUrl: String) async throws -> URL {
		queue.sync {
			invokedGetAuthenticationUrl = true
			invokedGetAuthenticationUrlCount += 1
			invokedGetAuthenticationUrlParameters = (callbackUrl, ())
			invokedGetAuthenticationUrlParametersList.append((callbackUrl, ()))
		}
	
		if let error = stubbedGetAuthenticationError {
			throw error
		}
			return stubbedGetAuthenticationUrl
	}
}
