/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import Testing
import RestrictedBrowser
import Foundation

@MainActor
final class LoginViewModelTests {
	
	private var coordinatorSpy: AppCoordinatorSpy
	private var remoteAuthenticationClientSpy: RemoteAuthenticationClientSpy
	private var sut: LoginViewModel
	private var servicesSpies: ServicesSpies
	private var urlOpenerSpy: URLOpenerSpy
	
	init() throws {
		let url = try #require(URL(string: "https://example.com"))
		coordinatorSpy = AppCoordinatorSpy()
		remoteAuthenticationClientSpy = RemoteAuthenticationClientSpy(serverUrl: url)
		servicesSpies = setupServicesSpies()
		urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		sut = LoginViewModel(
			coordinator: coordinatorSpy,
			mode: .firstTime,
			remoteAuthenticationClient: remoteAuthenticationClientSpy,
			urlOpener: urlOpenerSpy
		)
	}
	
	@Test("Reduce backButtonPressed should call coordinator")
	func reduce_backButtonPressed_shouldCallCoordinator() {
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}
	
	@Test("Reduce loginWithDigiD should open the authentication URL")
	func reduce_loginWithDigiD_shouldOpenAuthenticationURL() async throws {
		
		// Given
		let auth = try #require(URL(string: "https://example.com/auth"))
		await remoteAuthenticationClientSpy.setStubedGetAuthenticationUrl(auth)
		
		// When
		sut.reduce(.loginWithDigiD)
		
		// Then — coordinator is not called; the URL opener is invoked once the auth URL resolves
		#expect(coordinatorSpy.invokedHandle == false)
		try await Task.sleep(nanoseconds: 200 * 1_000_000)
		#expect(urlOpenerSpy.invokedCanOpenURL == true)
	}
}
