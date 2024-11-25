/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
import Zibs

final class HealthCategoryDataViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthCategoryDataViewModel!
	private var referenceResolverSpy: ReferenceResolverSpy!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		referenceResolverSpy = ReferenceResolverSpy()
		setupSut()
	}
	
	private func setupSut() {
		
		sut = HealthCategoryDataViewModel(
			coordinator: coordinatorSpy,
			title: "HealthCategoryDataViewModelTests",
			schema: UISchema(children: [UISchemaGroup(
				children: [
					UIEntry(
						display: UIEntryDisplay.string("single value"),
						label: "label single value",
						summary: true,
						type: .singleValue,
						reference: nil,
						url: nil
					),
					UIEntry(
						display: UIEntryDisplay.string("reference value"),
						label: "label reference",
						summary: true,
						type: .referenceValue,
						reference: "test_resolveReference",
						url: "reference/link"
					),
					UIEntry(
						display: nil,
						label: "label download link",
						summary: true,
						type: .downloadLink,
						reference: nil,
						url: "https://www.apple.com"
					)
				],
				label: "Section Header first group")
			],
			label: "test"),
			healthcareOrganization: Generator.healthcareOrganization("1"),
			referenceResolver: referenceResolverSpy
		)
	}

	func test_state() {
		
		// Given
		
		// When
		let state = sut.state
		
		// Then
		expect(state.title) == "HealthCategoryDataViewModelTests"
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
	
	func test_resolveReference_shouldCallCoordinator() throws {
		
		// Given
		let schema = UISchema(children: [], label: "test")
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReference"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategoryData.identifier
		expect(params.params["resource"] as? MgoResource) == Data()
		expect(params.params["heading"] as? String) == schema.label
		expect((params.params["uiSchema"] as? UISchema)?.label) == schema.label
	}
	
	func test_resolveReference_labelIsEmpty_shouldCallCoordinator() throws {
		
		// Given
		let schema = UISchema(children: [], label: nil)
		self.referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		setupSut()
		
		// When
		sut.reduce(.reference("test_resolveReference"))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategoryData.identifier
		expect(params.params["resource"] as? MgoResource) == Data()
		expect(params.params["heading"] as? String) == ""
		expect((params.params["uiSchema"] as? UISchema)?.label) == nil
	}
}
