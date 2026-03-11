/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// Full-screen cover content for the add-organisation confirmation dialog.
/// Handles its own fade-in/out animation: the transparent fullScreenCover container
/// is invisible during the UIKit slide, so only the opacity animation is perceived.
struct ConfirmationAlertCoverView: View {
	
	let organization: OrganizationSearch.Organization
	@Binding var isPresented: Bool
	let onConfirm: () -> Void
	/// Pass `true` in tests to skip the fade-in and render fully visible immediately.
	var startVisible: Bool = false

	@State private var isVisible = false
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker

	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	private struct ViewTraits {
		enum Animation {
			static let duration: Double = 0.25
		}
		enum Card {
			static let padding: CGFloat = 14
			static let cornerRadius: CGFloat = 34
			static let horizontalPadding: CGFloat = 40
			static let spacing: CGFloat = 10
		}
		enum TextSection {
			static let horizontalPadding: CGFloat = 8
			static let topPadding: CGFloat = 8
			static let bottomPadding: CGFloat = 24
		}
	}
	
	var body: some View {
		ZStack {
			Color.black.opacity(0.4)
				.ignoresSafeArea()
			
			card
		}
		.opacity(isVisible ? 1 : 0)
		.onAppear {
			if startVisible {
				isVisible = true
			} else {
				withAnimation(.easeInOut(duration: ViewTraits.Animation.duration)) {
					isVisible = true
				}
			}
		}
	}
	
	/// Title, body text and action buttons — the inner content of the card.
	@ViewBuilder private var cardContent: some View {
		VStack(spacing: ViewTraits.Card.spacing) {
			
			VStack(alignment: .leading, spacing: ViewTraits.Card.spacing) {
				Text(
					String(
						format: String(localized: "search_organization.dialog.heading"),
						arguments: [organization.displayName ?? ""]
					)
				)
				.typography(.bodyMedium, with: .semiBold)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .leading)
				
				Text(String(localized: "search_organization.dialog.subheading"))
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding(.horizontal, ViewTraits.TextSection.horizontalPadding)
			.padding(.top, ViewTraits.TextSection.topPadding)
			.padding(.bottom, ViewTraits.TextSection.bottomPadding)
			
			VStack(spacing: ViewTraits.Card.spacing) {
				CallToActionButton(
					"search_organization.dialog.yes",
					style: .solid(rounded: true, narrow: false)
				) {
					dismiss { onConfirm() }
				}
				.accessibilityIdentifier("search_organization.dialog.action")
				
				CallToActionButton(
					"search_organization.dialog.no",
					style: .tonal(rounded: true)
				) {
					dismiss {}
				}
				.accessibilityIdentifier("search_organization.dialog.cancel")
			}
		}
	}
	
	/// Card with background styling: Liquid Glass on iOS 26+, theme tertiary on iOS 18.
	@ViewBuilder private var card: some View {
		if #available(iOS 26, *), osVersionChecker.available(version: .iOS(.v26)) {
			cardContent
				.padding(ViewTraits.Card.padding)
				.glassEffect(in: RoundedRectangle(cornerRadius: ViewTraits.Card.cornerRadius))
				.padding(.horizontal, ViewTraits.Card.horizontalPadding)
		} else {
			cardContent
				.padding(ViewTraits.Card.padding)
				.background(theme.backgrounds.tertiary)
				.clipShape(RoundedRectangle(cornerRadius: ViewTraits.Card.cornerRadius))
				.padding(.horizontal, ViewTraits.Card.horizontalPadding)
		}
	}
	
	/// Fades out the content, then dismisses the cover without animation so the
	/// transparent container doesn't slide back down visibly.
	private func dismiss(completion: @escaping () -> Void) {
		withAnimation(.easeInOut(duration: ViewTraits.Animation.duration)) {
			isVisible = false
		}
		Task {
			try? await Task.sleep(nanoseconds: UInt64(ViewTraits.Animation.duration * 1_000_000_000))
			var transaction = Transaction()
			transaction.disablesAnimations = true
			withTransaction(transaction) {
				isPresented = false
			}
			completion()
		}
	}
}

extension View {
	
	/// Makes the fullScreenCover container transparent so only our custom dim + card is visible.
	/// Uses presentationBackground(.clear) on iOS 16.4+.
	/// On iOS 15–16.3 no transparency is applied; the dim overlay still covers the cover's background.
	@ViewBuilder func clearFullScreenCoverBackground() -> some View {
		if #available(iOS 16.4, *) {
			self.presentationBackground(.clear)
		} else {
			self
		}
	}
}
