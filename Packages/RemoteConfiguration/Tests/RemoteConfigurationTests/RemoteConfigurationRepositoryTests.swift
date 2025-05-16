/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import RemoteConfiguration
import MGOTest

final class RemoteConfigurationClientTests: XCTestCase {
	
	private var sut: RemoteConfigurationClient!
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com/v1/mgo"))
		sut = try XCTUnwrap(RemoteConfigurationClient(serverUrl: serverUrl))
	}
	
	func test_fetchRemoteConfig() async throws {
		
		// Given
		stub(condition: isPath("/v1/mgo/config")) { _ in
			return HTTPStubsResponse(jsonObject: ["iosMinimumVersion": "1.2.3"], statusCode: 200, headers: nil)
		}
		// When
		let remoteConfig = try await sut.fetchRemoteConfig()
		
		// Then
		expect(remoteConfig.iosMinimumVersion) == "1.2.3"
	}
}
