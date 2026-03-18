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
	
	/// The selected organization to confirm adding to the user's list.
	let organization: OrganizationSearch.Organization
	
	/// Binding that controls the presentation of the full-screen cover.
	@Binding var isPresented: Bool
	
	/// Callback invoked after the user confirms and the cover is dismissed.
	let onConfirm: () -> Void
	
	/// When `true`, skips the fade-in animation and renders the content fully visible immediately.
	/// Useful in UI tests to avoid flakiness due to timing.
	var startVisible: Bool = false

	/// Internal visibility state that drives the fade-in/out opacity animation.
	@State private var isVisible = false
	
	/// Injected helper used to check OS availability at runtime.
	@Injected(\.osVersionChecker) private var osVersionChecker

	/// Current theme from the environment for colors and typography.
	@Environment(\.mgoTheme) var theme
	
	private struct ViewTraits {
		/// Visual constants that define layout, spacing and animation timing for this view.
		
		/// Animation-related constants.
		enum Animation {
			/// Duration (seconds) for fade-in/out animations.
			static let duration: Double = 0.25
		}
		
		/// Card layout constants.
		enum Card {
			/// Inner padding of the card content.
			static let padding: CGFloat = 14
			/// Corner radius of the card background.
			static let cornerRadius: CGFloat = 34
			/// Horizontal margin from screen edges.
			static let horizontalPadding: CGFloat = 40
			/// Vertical spacing between elements inside the card.
			static let spacing: CGFloat = 10
		}
		
		/// Text section spacing constants.
		enum TextSection {
			/// Horizontal padding around the text block.
			static let horizontalPadding: CGFloat = 8
			/// Top padding above the text block.
			static let topPadding: CGFloat = 8
			/// Bottom padding below the text block.
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
			
			textSection
			
			buttonSection
		}
	}
	
	/// Text section with heading and subheading, wrapped and padded.
	@ViewBuilder private var textSection: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Card.spacing) {
			Text(
				String(
					format: String(localized: "search_organization.dialog.heading"),
					arguments: [organization.name ?? ""]
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
	}
	
	/// Button section with primary and secondary actions.
	@ViewBuilder private var buttonSection: some View {
		VStack(spacing: ViewTraits.Card.spacing) {
			CallToActionButton(
				"search_organization.dialog.yes",
				style: .solid(rounded: true, narrow: false),
				action: confirmTapped
			)
			.accessibilityIdentifier("search_organization.dialog.action")

			CallToActionButton(
				"search_organization.dialog.no",
				style: .tonal(rounded: true),
				action: cancelTapped
			)
			.accessibilityIdentifier("search_organization.dialog.cancel")
		}
	}

	private func confirmTapped() {
		dismiss { onConfirm() }
	}

	private func cancelTapped() {
		dismiss { /* no-op: user cancelled, nothing to do after fade-out */ }
	}
	
	/// Card with background styling: uses Liquid Glass on iOS 26+; falls back to the theme's tertiary background on earlier iOS versions.
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
	
	/// Fades out the content and then dismisses the cover without animation.
	/// Disabling the dismissal animation avoids the fullScreenCover's slide-out being visible.
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
	
	/// Makes the fullScreenCover container transparent so only our custom dim and card are visible.
	/// Uses presentationBackground(.clear) on iOS 16.4+.
	/// On iOS 15–16.3 no transparency is applied; the dim overlay still obscures the cover's default background.
	@ViewBuilder func clearFullScreenCoverBackground() -> some View {
		if #available(iOS 16.4, *) {
			self.presentationBackground(.clear)
		} else {
			self
		}
	}
}
