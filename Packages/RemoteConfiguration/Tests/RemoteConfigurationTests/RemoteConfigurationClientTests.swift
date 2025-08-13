/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RemoteConfiguration
import Testing
import OHHTTPStubs
import OHHTTPStubsSwift

class RemoteConfigurationClientTests {
	
	deinit {
		HTTPStubs.removeAllStubs()
	}
	
	@Test
	func client() async throws {
		
		// Given
		stub(condition: isPath("/v1/mgo/config")) { _ in
			return HTTPStubsResponse(
				jsonObject: ["iosMinimumVersion": "1.2.3"],
				statusCode: 200,
				headers: nil
			)
		}
		let serverUrl = try #require(URL(string: "https://example.com/v1/mgo"))
		let sut = RemoteConfigurationClient(serverUrl: serverUrl)
		
		// When
		let remoteConfig = try await sut.fetchRemoteConfig()
		
		// Then
		#expect(remoteConfig.iosMinimumVersion == "1.2.3")
	}
	
	@Test
	func client_withBasicAuth() async throws {
		
		// Given
		stub(condition: isPath("/v1/mgo/config")) { _ in
			return HTTPStubsResponse(
				jsonObject: ["iosMinimumVersion": "1.2.3"],
				statusCode: 200,
				headers: nil
			)
		}
		let serverUrl = try #require(URL(string: "https://example.com/v1/mgo"))
		let sut = RemoteConfigurationClient(
			serverUrl: serverUrl,
			username: "test",
			password: "test"
		)
		
		// When
		let remoteConfig = try await sut.fetchRemoteConfig()
		
		// Then
		#expect(remoteConfig.iosMinimumVersion == "1.2.3")
	}
}
