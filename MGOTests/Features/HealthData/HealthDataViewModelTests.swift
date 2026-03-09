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
	}
	
	@MainActor private func setupSut() {
		
		sut = HealthDataViewModel(
			coordinator: coordinatorSpy,
			config: HealthDataViewConfig(
				backButtonTitle: "HealthCategoryDataViewModelTests",
				titleInline: false,
				inSheet: false
			),
			schema: HealthUISchema(
				children: [
					HealthUIGroup(
						children: [
							UIElement(
								label: "label single value",
								type: .singleValue,
								value: UIElementValue
									.displayValue(
										DisplayValue(
											code: nil,
											display: "single value",
											system: nil
										)
									),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								label: "label reference",
								type: .referenceValue,
								value: nil,
								display: "reference value",
								reference: "test_resolveReference",
								url: "reference/link"
							),
							UIElement(
								label: "label reference link",
								type: .referenceLink,
								value: nil,
								display: nil,
								reference: "test_resolveReferenceLink",
								url: "reference/link"
							),
							UIElement(
								label: "label download link",
								type: .downloadLink,
								value: nil,
								display: nil,
								reference: nil,
								url: "https://www.apple.com"
							),
							UIElement(
								label: "label snomed code",
								type: .singleValue,
								value: UIElementValue
									.displayValue(
										DisplayValue(
											code: "code",
											display: "display",
											system: "http://snomed.info/sct"
										)
									),
								display: nil,
								reference: nil,
								url: nil
							),
							UIElement(
								label: "label non snomed code",
								type: .singleValue,
								value: UIElementValue
									.displayValue(
										DisplayValue(
											code: "code",
											display: "display",
											system: "syste,"
										)
									),
								display: nil,
								reference: nil,
								url: nil
							)
						],
						label: "Section Header first group"
					)
				],
				label: "test"
			),
			healthcareOrganization: Generator.healthcareOrganization("1"),
			referenceResolver: referenceResolverSpy
		)
	}
	
	@MainActor func test_state() {
		
		// Given
		setupSut()
		
		// When
		let state = sut.state
		
		// Then
		expect(state.backButton) == "HealthCategoryDataViewModelTests"
		expect(state.schema.label) == "test"
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}

	@MainActor func test_closeSheet_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_resolveReferenceValue_shouldCallCoordinator() throws {
		
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
	
	@MainActor func test_resolveReferenceLink_shouldCallCoordinator() throws {
		
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
	
	@MainActor func test_resolve_term() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		setupSut()
		
		// When
		sut.reduce(
			.term(
				DisplayValue(
					code: "code",
					display: "display",
					system: "http://snomed.info/sct"
				)
			)
		)
		
		// Then
		expect(self.sut.selectedPatientFriendlyTerm) == term
	}
	
	@MainActor func test_resolve_invalidTerm() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		setupSut()
		
		// When
		sut.reduce(
			.term(
				DisplayValue(
					code: "other code",
					display: "display",
					system: "http://snomed.info/sct"
				)
			)
		)
		
		// Then
		expect(self.sut.selectedPatientFriendlyTerm) == nil
	}
	
	@MainActor func test_resolve_closeTermSheet() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		setupSut()
		sut.selectedPatientFriendlyTerm = term
		
		// When
		sut.reduce(.closeTermSheet)
		
		// Then
		expect(self.sut.selectedPatientFriendlyTerm) == nil
	}
}
