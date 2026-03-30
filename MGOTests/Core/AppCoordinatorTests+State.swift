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
		let browser = RestrictedBrowser(
			allowedDomains: ["irealisatie.nl"],
			urlOpener: urlOpenerSpy
		)
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
		
		// Then
		let splashView = try view.inspect().find(SplashView.self)
		expect(splashView) != nil
	}
	
	@MainActor func test_coordinatorView_forRequiredUpdate() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.updateRequired
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let updateRequiredView = try view.inspect().find(UpdateRequiredView.self)
		expect(updateRequiredView) != nil
	}
	
	@MainActor func test_coordinatorView_forIntroduction() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.introduction
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let introductionView = try view.inspect().find(IntroductionView.self)
		expect(introductionView) != nil
	}
	
	@MainActor func test_coordinatorView_forProposition() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.proposition
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let propositionView = try view.inspect().find(PropositionView.self)
		expect(propositionView) != nil
	}
	
	@MainActor func test_coordinatorView_privacyStatement() throws {
		
		// Given
		setupSut()
		let url = try XCTUnwrap(LinkRepository.privacyURL)
		let state = AppCoordination.State.browser(url, "privacy.heading")
		
		// When
		let view = sut.view(for: state)
		let content = NavigationStackBackport.NavigationStack { view }
		let webview = try content.inspect()
			.find(viewWithAccessibilityIdentifier: "restrictedBrowserView")
		
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
		
		// Then
		let loginView = try view.inspect().find(LoginView.self)
		expect(loginView) != nil
	}
	
	@MainActor func test_coordinatorView_forDashboard() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.dashboard
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let dashboardView = try view.inspect().find(DashboardCoordinatorView<DashboardCoordinator>.self)
		expect(dashboardView) != nil
	}
	
	@MainActor func test_coordinatorView_forManualLocalization() throws {
		
		// Given
		setupSut()
		let state = AppCoordination.State.manualLocalization
		
		// When
		let view = sut.view(for: state)
		
		// Then
		let searchOrganizationView = try view.inspect().find(SearchOrganizationView.self)
		expect(searchOrganizationView) != nil
	}
}
