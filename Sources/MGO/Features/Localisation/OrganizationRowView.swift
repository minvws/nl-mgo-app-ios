/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// A single row in the organization search results list.
///
/// Renders an organization as a `CardView` inside a `Button`. The entire list row —
/// including its insets — is highlighted with `theme.backgrounds.tertiary` while the
/// button is held down, and reverts to `theme.backgrounds.secondary` when released.
///
/// The press state is propagated upward from `PressReportingButtonStyle` via
/// `PressedPreferenceKey` and applied to `.listRowBackground`, so the highlight covers
/// the full row rather than just the button label.
///
/// Tapping a `.selected` or `.notParticipating` row has no effect; only `.regular` rows
/// invoke `onSelect`.
struct OrganizationRowView: View {

	/// The organization to display.
	let organization: Organization

	/// The card state that determines label text, chevron visibility, and tap behaviour.
	let cardState: SearchOrganizationView.CardState

	/// Called when the user taps a `.regular` row.
	let onSelect: () -> Void

	/// Tracks whether the button is currently pressed, driven by `PressedPreferenceKey`.
	@State private var isPressed = false

	/// The current theme, used for row background colours.
	@Environment(\.theme) private var theme

	var body: some View {
		Button {
			guard cardState == .regular else { return }
			onSelect()
		} label: {
			CardView(
				title: organization.displayName ?? "",
				message: (
					(organization.address.addressLine ?? "") + ", " + (organization.address.city ?? "")
				).trim(),
				details: {
					switch cardState {
						case .regular: return nil
						case .selected: return String(localized: "search_organization.already_added")
						case .notParticipating: return String(localized: "search_organization.not_participating")
					}
				}(),
				showChevron: cardState == .regular
			)
			.contentShape(Rectangle())
			.accessibilityElement(children: .combine)
		}
		.accessibilityIdentifier("button_\(organization.id)")
		.buttonStyle(PressReportingButtonStyle(isPressed: $isPressed))
		.onPreferenceChange(PressedPreferenceKey.self) { isPressed = $0 }
		.listRowBackground(isPressed ? theme.backgrounds.tertiary : theme.backgrounds.secondary)
	}
}
