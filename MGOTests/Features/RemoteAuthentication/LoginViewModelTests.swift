/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
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
		remoteAuthenticationClientSpy = RemoteAuthenticationClientSpy(serverUrl: url)
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		
		super.setUp()
	}
	
	@MainActor private func createSut() {
		
		sut = LoginViewModel(
			coordinator: coordinatorSpy,
			mode: .firstTime,
			remoteAuthenticationClient: remoteAuthenticationClientSpy,
			urlOpener: urlOpenerSpy
		)
	}
	
	@MainActor func test_loginWithDigiD() async throws {
		
		// Given
		createSut()
		let auth = try XCTUnwrap(URL(string: "https://example.com/auth"))
		await remoteAuthenticationClientSpy.setStubedGetAuthenticationUrl(auth)
		
		// When
		sut.reduce(.loginWithDigiD)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		await expect { self.urlOpenerSpy.invokedCanOpenURL }
			.toEventually(beTrue())
	}
}
