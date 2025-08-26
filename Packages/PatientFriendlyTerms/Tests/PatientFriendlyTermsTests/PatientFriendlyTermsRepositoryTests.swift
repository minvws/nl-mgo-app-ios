/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import PatientFriendlyTerms
import Foundation
import FileStorage

class PatientFriendlyTermsRepositoryTests {
	
	var sut: PatientFriendlyTermsRepository!
	var client: PatientFriendlyTermsAPIClientProtocolSpy!
	var storage: FileStorageSpy!
	
	let eTag = "\"123\""
	
	init() throws {
		
		let serverUrl = try #require(URL(string: "https://example.com"))
		client = PatientFriendlyTermsAPIClientProtocolSpy(serverUrl)
		storage = FileStorageSpy()
		sut = PatientFriendlyTermsRepository(client: client, storage: storage)
	}

	@Test("fetch should call the client and store the result")
	func fetchTerms_storeResult() async throws {
		
		// Given
		sut.eTag = nil
		let terms = PatientFriendlyTerms(
			additionalProperties:
				[
					"100": PatientFriendlyTerm(
						name: "name",
						description: "description",
						synonym: "synonym"
					)
				]
		)
		client.stubbedFetchTerms = (200, eTag, terms)
		
		// When
		await sut.fetchTerms()
		
		// Then
		#expect(sut.eTag == eTag)
		#expect(storage.invokedStore == true)
	}
	
	@Test("fetch should call the client and just set the etag on 304 result")
	func fetchTerms_notModified() async throws {
		
		// Given
		client.stubbedFetchTerms = (304, eTag, nil)
		
		// When
		await sut.fetchTerms()
		
		// Then
		#expect(sut.eTag == eTag)
	}
	
	@Test("wipePersistedData should remove the stored data")
	func wipePersistedData() {
		
		// Given
		sut.eTag = "\"123\""
		
		// When
		sut.wipePersistedData()
		
		// Then
		#expect(storage.invokedRemove == true)
		#expect(sut.eTag == nil)
	}
}
