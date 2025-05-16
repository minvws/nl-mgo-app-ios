/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import RestrictedBrowser

final class LoginViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var remoteAuthenticationClientSpy: RemoteAuthenticationClientSpy!
	private var sut: LoginViewModel!
	private var servicesSpies: ServicesSpies!
	private var urlOpenerSpy: URLOpenerSpy!
	
	override func setUpWithError() throws {
		
		coordinatorSpy = AppCoordinatorSpy()
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		remoteAuthenticationClientSpy = RemoteAuthenticationClientSpy(serverUrl: url, username: nil, password: nil)
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		sut = LoginViewModel(
			coordinator: coordinatorSpy,
			remoteAuthenticationClient: remoteAuthenticationClientSpy,
			urlOpener: urlOpenerSpy
		)
		super.setUp()
	}

	func test_loginWithDigiD_shouldCallCoordinator_whenDemoMode() {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		
		// When
		sut.reduce(.loginWithDigiD)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.loggedInWithDigiD
	}
	
	func test_loginWithDigiD() throws {
		
		// Given
		let auth = try XCTUnwrap(URL(string: "https://example.com/auth"))
		remoteAuthenticationClientSpy.stubbedGetAuthenticationUrl = auth
		servicesSpies.featureFlagSpy.stubbedIsDemo = false
		
		// When
		sut.reduce(.loginWithDigiD)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.urlOpenerSpy.invokedCanOpenURL).toEventually(beTrue())
	}
}
