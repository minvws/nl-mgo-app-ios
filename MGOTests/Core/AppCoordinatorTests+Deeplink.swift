/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import RemoteConfiguration
import RestrictedBrowser

final class AppCoordinatorDeepLinkTests: XCTestCase {
	
	private var sut: AppCoordinator!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
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
	
	@MainActor func test_handle_deepLink() throws {
		
		// Given
		setupSut()
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = true
		let url = try XCTUnwrap(URL(string: "mgo-dev://app/login?userinfo=TEST"))
		
		// When		
		sut.handle(Coordination.Action(identifier: "deeplink", params: ["deeplink": url]))
		
		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == AppCoordination.State.manualLocalization
		expect(self.servicesSpies.secureUserSettingsSpy.invokedFirstTimeVisitorSetter) == true
	}
	
	@MainActor func test_digidDeeplink() throws {
		
		// Given
		setupSut()
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = true
		let url = try XCTUnwrap(URL(string: "mgo-dev://app/login?userinfo=TEST"))
		let deeplink = try XCTUnwrap(DeepLinkFactory().create(url))

		// When
		sut.consume(deeplink)

		// Then
		expect(self.sut.showChildCoordinator) == false
		expect(self.sut.path.isEmpty) == true
		expect(self.sut.rootState) == AppCoordination.State.manualLocalization
		expect(self.servicesSpies.secureUserSettingsSpy.invokedFirstTimeVisitorSetter) == true
	}

	@MainActor func test_digidDeeplink_repeatVisitor() throws {

		// Given
		setupSut()
		servicesSpies.secureUserSettingsSpy.stubbedFirstTimeVisitor = false
		let url = try XCTUnwrap(URL(string: "mgo-dev://app/login?userinfo=TEST"))
		let deeplink = try XCTUnwrap(DeepLinkFactory().create(url))
		
		// When
		sut.consume(deeplink)
		
		// Then
		expect(self.sut.showChildCoordinator) == true
	}
}
