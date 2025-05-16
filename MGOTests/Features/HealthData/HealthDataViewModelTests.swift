/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthDataViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthDataViewModel!
	private var referenceResolverSpy: ReferenceResolverSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		referenceResolverSpy = ReferenceResolverSpy()
		setupSut()
	}
	
	private func setupSut() {
		
		sut = HealthDataViewModel(
			coordinator: coordinatorSpy,
			schema: HealthUISchema(children: [HealthUIGroup(
				children: [
					UIElement(
						display: UIElementDisplay.string("single value"),
						label: "label single value",
						type: .singleValue,
						reference: nil,
						url: nil
					),
					UIElement(
						display: UIElementDisplay.string("reference value"),
						label: "label reference",
						type: .referenceValue,
						reference: "test_resolveReference",
						url: "reference/link"
					),
					UIElement(
						display: nil,
						label: "label reference link",
						type: .referenceLink,
						reference: "test_resolveReferenceLink",
						url: "reference/link"
					),
					UIElement(
						display: nil,
						label: "label download link",
						type: .downloadLink,
						reference: nil,
						url: "https://www.apple.com"
					)
				],
				label: "Section Header first group")
			],
			label: "test"),
			backButtonTitle: "HealthCategoryDataViewModelTests",
			healthcareOrganization: Generator.healthcareOrganization("1"),
			referenceResolver: referenceResolverSpy
		)
	}

	func test_state() {
		
		// Given
		
		// When
		let state = sut.state
		
		// Then
		expect(state.backButton) == "HealthCategoryDataViewModelTests"
		expect(state.schema.label) == "test"
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_resolveReferenceValue_shouldCallCoordinator() throws {
		
		// Given
		let schema = HealthUISchema(children: [], label: "test")
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReference"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthData.identifier
		expect(params.params["resource"] as? MgoResource) == Data()
		expect(params.params["backButtonTitle"] as? String) == "common.previous"
		expect((params.params["uiSchema"] as? HealthUISchema)?.label) == schema.label
	}
	
	func test_resolveReferenceLink_shouldCallCoordinator() throws {
		
		// Given
		let schema = HealthUISchema(children: [], label: "test")
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReferenceLink"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthData.identifier
		expect(params.params["resource"] as? MgoResource) == Data()
		expect(params.params["backButtonTitle"] as? String) == "common.previous"
		expect((params.params["uiSchema"] as? HealthUISchema)?.label) == schema.label
	}
	
	func test_resolveReferenceValue_demoMode_shouldNotCallCoordinator() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		let schema = HealthUISchema(children: [], label: "test")
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReference"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	func test_resolveReferenceLink_demoMode_shouldCallCoordinator() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		let schema = HealthUISchema(children: [], label: "test")
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReferenceLink"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthData.identifier
		expect(params.params["resource"] as? MgoResource) == Data()
		expect(params.params["backButtonTitle"] as? String) == "common.previous"
		expect((params.params["uiSchema"] as? HealthUISchema)?.label) == schema.label
	}
}
