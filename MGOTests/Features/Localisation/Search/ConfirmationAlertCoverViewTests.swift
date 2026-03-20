/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI
import OrganizationSearch
import Testing

@MainActor
final class ConfirmationAlertCoverViewTests {

	private var servicesSpies: ServicesSpies!

	private let organization: OrganizationSearch.Organization =
		Generator.searchOrganization(
			id: "org-1",
			displayName: "Radboudumc",
			city: "Nijmegen",
			address: "Geert Grooteplein 10",
			postalCode: "6525GA",
			dataServices: [
				OrganizationSearch.DataService(
					id: "50",
					authEndpoint: "test",
					resourceEndpoint: "test",
					tokenEndpoint: "test"
				)
			]
		)

	init() {
		servicesSpies = setupServicesSpies()
	}

	// MARK: - Snapshot Tests

	@Test func snapshot_confirmationDialog() {

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

		takeSnapShots(content: content)
	}

	@Test func snapshot_confirmationDialog_iOS18() {

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

		takeSnapShots(content: content)
	}

	// MARK: - Interaction Tests

	@Test func yesButton_shouldCallOnConfirm() async throws {

		try await confirmation("onConfirm called") { confirm in

			// Given
			let sut = ConfirmationAlertCoverView(
				organization: organization,
				isPresented: .constant(true),
				onConfirm: { confirm() }
			)

			// When
			let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "search_organization.dialog.action")
			try view.view(CallToActionButton.self).find(button: "search_organization.dialog.yes").tap()

			// Then — wait for the 250ms dismiss animation before onConfirm is invoked
			try await Task.sleep(nanoseconds: 350_000_000)
		}
	}

	@Test func cancelButton_shouldDismiss() async throws {

		try await confirmation("isPresented set to false") { confirm in

			// Given
			let sut = ConfirmationAlertCoverView(
				organization: organization,
				isPresented: Binding(
					get: { true },
					set: { newValue in
						if !newValue { confirm() }
					}
				),
				onConfirm: {}
			)

			// When
			let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "search_organization.dialog.cancel")
			try view.view(CallToActionButton.self).find(button: "search_organization.dialog.no").tap()

			// Then — wait for the 250ms dismiss animation before isPresented is set to false
			try await Task.sleep(nanoseconds: 350_000_000)
		}
	}
}
