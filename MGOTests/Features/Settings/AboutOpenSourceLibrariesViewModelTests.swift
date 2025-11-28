/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO
import MGOUI

final class AboutOpenSourceLibrariesViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AboutOpenSourceLibrariesViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor func setupSut() {
		
		sut = AboutOpenSourceLibrariesViewModel(
			coordinator: self.coordinatorSpy
		)
	}
	
	@MainActor func test_backButtonPressed() throws {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.backButtonPressed)

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_handleOpenUrl() throws {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.openUrl("https://example.com"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.openUrl.identifier
		expect(params.params["urlString"]) != nil
	}
	
	@MainActor func test_libraries() throws {
		
		// Given
		setupSut()
		let expectedLibrary = AboutOpenSourceLibrariesViewModel.Library(
			name: "DeviceKit (MIT)",
			urlString: "https://github.com/devicekit/DeviceKit?tab=MIT-1-ov-file#readme" // NOSONAR
		)
		
		// When
		let actualLibrary = try XCTUnwrap(sut.libraries.first { $0.name == expectedLibrary.name })
		
		// Then
		expect(expectedLibrary.name) == actualLibrary.name
		expect(expectedLibrary.urlString) == actualLibrary.urlString
		expect(expectedLibrary.id) != actualLibrary.id
		expect(expectedLibrary) != actualLibrary
	}
}
