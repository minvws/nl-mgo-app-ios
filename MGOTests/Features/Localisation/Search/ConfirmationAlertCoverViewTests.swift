/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI
import OrganizationSearch

final class ConfirmationAlertCoverViewTests: XCTestCase {

	private var servicesSpies: ServicesSpies!

	private var organization: OrganizationSearch.Organization {
		Generator.searchOrganization(
			id: "org-1",
			displayName: "Radboudumc",
			city: "Nijmegen",
			addressLine: "Geert Grooteplein 10",
			postalCode: "6525GA",
			dataServices: [
				"50": OrganizationSearch.DataService(
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)
	}

	override func setUpWithError() throws {

		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
	}

	// MARK: - Snapshot Tests

	@MainActor func test_snapshot_confirmationDialog() {

		// When — startVisible: true skips the fade-in so the view is fully opaque from the
		// first frame, giving a deterministic snapshot regardless of RunLoop timing.
		// A white background makes the semi-transparent overlay clearly visible.
		let content = ZStack {
			Color.white.ignoresSafeArea()
			ConfirmationAlertCoverView(
				organization: organization,
				isPresented: .constant(true),
				onConfirm: {},
				startVisible: true
			)
		}

		// Then
		takeSnapShots(content: content)
	}

	@MainActor func test_snapshot_confirmationDialog_iOS18() {

		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }

		// When — startVisible: true skips the fade-in so the view is fully opaque from the
		// first frame, giving a deterministic snapshot regardless of RunLoop timing.
		// A white background makes the semi-transparent overlay clearly visible.
		let content = ZStack {
			Color.white.ignoresSafeArea()
			ConfirmationAlertCoverView(
				organization: organization,
				isPresented: .constant(true),
				onConfirm: {},
				startVisible: true
			)
		}

		// Then
		takeSnapShots(content: content)
	}

	// MARK: - Interaction Tests

	@MainActor func test_yesButton_shouldCallOnConfirm() async throws {

		// Given
		let expectation = XCTestExpectation(description: "onConfirm called")
		let sut = ConfirmationAlertCoverView(
			organization: organization,
			isPresented: .constant(true),
			onConfirm: { expectation.fulfill() }
		)

		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "search_organization.dialog.action")
		try view.view(CallToActionButton.self).find(button: "search_organization.dialog.yes").tap()

		// Then — wait for the 250ms dismiss animation before onConfirm is invoked
		await fulfillment(of: [expectation], timeout: 1.0)
	}

	@MainActor func test_cancelButton_shouldDismiss() async throws {

		// Given
		let expectation = XCTestExpectation(description: "isPresented set to false")
		var isPresented = true
		let sut = ConfirmationAlertCoverView(
			organization: organization,
			isPresented: Binding(
				get: { isPresented },
				set: { newValue in
					isPresented = newValue
					if !newValue { expectation.fulfill() }
				}
			),
			onConfirm: {}
		)

		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "search_organization.dialog.cancel")
		try view.view(CallToActionButton.self).find(button: "search_organization.dialog.no").tap()

		// Then — wait for the 250ms dismiss animation before isPresented is set to false
		await fulfillment(of: [expectation], timeout: 1.0)
	}
}
