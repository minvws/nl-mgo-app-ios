/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import RestrictedBrowser

final class AppCoordinatorStateTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
	}
	
	@MainActor func setupSut() {
		
		let urlOpenerSpy = URLOpenerSpy()
		urlOpenerSpy.stubbedCanOpenURLResult = true
		let browser = RestrictedBrowser(allowedDomains: ["irealisatie.nl"], urlOpener: urlOpenerSpy)
		sut = AppCoordinator(
			path: NavigationStackBackport.NavigationPath(),
			browser: browser
		)
	}
	
	// MARK: - State -
	
	@MainActor func test_coordinatorView_forLaunch() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.splash
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.90) // Lower precision due to random position of spinner
	}
	
	@MainActor func test_coordinatorView_forRequiredUpdate() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.updateRequired
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_forIntroduction() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.introduction
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_forProposition() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.proposition
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_privacyStatement() throws {
		
		// Given
		setupSut()
		let url = try XCTUnwrap(LinkRepository.privacyURL)
		let state = AppCoordination.State.browser(url, "privacy.heading")
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		let webview = try content.inspect().find(viewWithAccessibilityIdentifier: "restrictedBrowserView")
		
		// Then
		expect(webview) != nil
	}
	
	@MainActor func test_coordinatorView_forLogin() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = true
		setupSut()
		let state = AppCoordination.State.login
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_forLoginInfo() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.loginInfo
		servicesSpies.secureUserSettingsSpy.stubbedUserHasRemoteAuthentication = true
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_forDashboard() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.dashboard
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_coordinatorView_forAutomaticLocalization() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.automaticLocalization
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_coordinatorView_forManualLocalization() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.manualLocalization
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_coordinatorView_forHealthcareOrganizationSearchResults() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.view(for: state)
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
