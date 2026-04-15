/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthDataViewModelTests {
	
	private let coordinatorSpy: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies
	private let referenceResolverSpy: ReferenceResolverSpy
	
	init() {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		referenceResolverSpy = ReferenceResolverSpy()
	}
	
	private func makeSut() -> HealthDataViewModel {
		HealthDataViewModel(
			coordinator: coordinatorSpy,
			config: HealthDataViewConfig(
				backButtonTitle: "HealthCategoryDataViewModelTests",
				inSheet: false
			),
			schema: HealthUISchema(
				children: [
					HealthUIGroup(
						children: [
							UIElement(
								id: "label_single_value",
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
								id: "label_reference",
								label: "label reference",
								type: .referenceValue,
								value: nil,
								display: "reference value",
								reference: "test_resolveReference",
								url: "reference/link"
							),
							UIElement(
								id: "label_reference_link",
								label: "label reference link",
								type: .referenceLink,
								value: nil,
								display: nil,
								reference: "test_resolveReferenceLink",
								url: "reference/link"
							),
							UIElement(
								id: "label_download_link",
								label: "label download link",
								type: .downloadLink,
								value: nil,
								display: nil,
								reference: nil,
								url: "https://www.apple.com"
							),
							UIElement(
								id: "label_snomed_code",
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
								id: "label_non_snomed_code",
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
						excludeFromPrint: false,
						id: "section_header_first_group",
						label: "Section Header first group"
					)
				],
				label: "test"
			),
			healthcareOrganization: Generator.healthcareOrganization("1"),
			referenceResolver: referenceResolverSpy
		)
	}
	
	@Test("Initial state has correct backButton title and schema label")
	func state() {
		
		// Given
		let sut = makeSut()
		
		// Then
		#expect(sut.state.backButton == "HealthCategoryDataViewModelTests")
		#expect(sut.state.schema.label == "test")
	}
	
	// MARK: - Basic interaction
	
	@Test("Tapping back calls coordinator with backButtonPressed")
	func backButtonPressed_shouldCallCoordinator() {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}
	
	@Test("Tapping close calls coordinator with closeSheet")
	func closeSheet_shouldCallCoordinator() {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.closeSheet)
	}
	
	// MARK: - References
	
	@Test("Tapping a referenceValue reference navigates to showHealthData")
	func resolveReferenceValue_shouldCallCoordinator() throws {
		
		// Given
		let schema = HealthUISchema(children: [], label: "test")
		referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		let sut = makeSut()
		
		// When
		sut.reduce(.reference("test_resolveReference"))
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.showHealthData.identifier)
		#expect(params.params["resource"] as? MgoResource == Data())
		#expect(params.params["backButtonTitle"] as? String == "common.previous")
		#expect((params.params["uiSchema"] as? HealthUISchema)?.label == schema.label)
	}
	
	@Test("Tapping a referenceLink reference navigates to showHealthData")
	func resolveReferenceLink_shouldCallCoordinator() throws {
		
		// Given
		let schema = HealthUISchema(children: [], label: "test")
		referenceResolverSpy.stubbedResolveResult = (Data(), schema)
		let sut = makeSut()
		
		// When
		sut.reduce(.reference("test_resolveReferenceLink"))
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.showHealthData.identifier)
		#expect(params.params["resource"] as? MgoResource == Data())
		#expect(params.params["backButtonTitle"] as? String == "common.previous")
		#expect((params.params["uiSchema"] as? HealthUISchema)?.label == schema.label)
	}
	
	// MARK: - Patient Friendly Term
	
	@Test("Tapping a SNOMED term with known code sets selectedPatientFriendlyTerm")
	func resolve_term() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		let sut = makeSut()
		
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
		#expect(sut.selectedPatientFriendlyTerm == term)
	}
	
	@Test("Tapping a SNOMED term with unknown code leaves selectedPatientFriendlyTerm nil")
	func resolve_invalidTerm() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		let sut = makeSut()
		
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
		#expect(sut.selectedPatientFriendlyTerm == nil)
	}
	
	@Test("closeTermSheet clears selectedPatientFriendlyTerm")
	func resolve_closeTermSheet() {
		
		// Given
		let term = PatientFriendlyTerm(description: "Test")
		servicesSpies.patientFriendlyTermsRepositorySpy.stubbedFindResult = term
		let sut = makeSut()
		sut.selectedPatientFriendlyTerm = term
		
		// When
		sut.reduce(.closeTermSheet)
		
		// Then
		#expect(sut.selectedPatientFriendlyTerm == nil)
	}
	
	// MARK: - Export
	
	@Test("showExportAlert sets showExportAlert to true")
	func showExportAlert() {
		
		// Given
		let sut = makeSut()
		sut.state.showExportAlert = false
		
		// When
		sut.reduce(.showExportAlert)
		
		// Then
		#expect(sut.state.showExportAlert == true)
	}
	
	@Test("cancelExportAlert sets showExportAlert to false")
	func cancelExportAlert() {
		
		// Given
		let sut = makeSut()
		sut.state.showExportAlert = true
		
		// When
		sut.reduce(.cancelExportAlert)
		
		// Then
		#expect(sut.state.showExportAlert == false)
	}
	
	@Test("exportHealthData calls coordinator with exportHealthData identifier")
	func exportHealthData_list_shouldCallCoordinator() throws {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.exportHealthData)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0.identifier == Coordination.Action.exportHealthData.identifier)
		#expect(coordinatorSpy.invokedHandleParameters?.0.params != nil)
	}
}
