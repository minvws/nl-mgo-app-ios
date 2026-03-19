/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import PatientFriendlyTerms
import Foundation

public final class PatientFriendlyTermsAPIClientProtocolSpy: PatientFriendlyTermsAPIClientProtocol, @unchecked Sendable {
	
	public required init(_ url: Foundation.URL, username: String, password: String) {
		/* required public initizaler*/
	}

	public required init(_ url: Foundation.URL) {
		/* required public initizaler*/
	}

	public var invokedFetchTerms = false
	public var invokedFetchTermsCount = 0
	public var invokedFetchTermsParameters: (eTag: String?, Void)?
	public var invokedFetchTermsParametersList = [(eTag: String?, Void)]()
	public var stubbedError: Error?
	public var stubbedFetchTerms: (statusCode: Int, eTag: String?, terms: PatientFriendlyTerms?)! = (200, nil, nil)
	
	private let queue = DispatchQueue(label: "com.PatientFriendlyTermsAPIClientProtocolSpy.serialqueue.\(UUID().uuidString)")
	
	public func fetchTerms(eTag: String?) async throws ->
	(statusCode: Int, eTag: String?, terms: PatientFriendlyTerms?) {
		queue.sync {
			invokedFetchTerms = true
			invokedFetchTermsCount += 1
			invokedFetchTermsParameters = (eTag, ())
			invokedFetchTermsParametersList.append((eTag, ()))
		}
		
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchTerms
	}
}
