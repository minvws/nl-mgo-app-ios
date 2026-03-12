/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct SettingsRowView: View {
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The icon to display at the leading side of the row
	private var icon: Image?
	
	/// The background color for that icon
	private var iconBackground: Color?
	
	/// The main heading for the row
	private var heading: LocalizedStringKey
	
	/// An optional second sub heading
	private var subHeading: LocalizedStringKey?
	
	/// Should we show the trailing chevron
	private var showChevron: Bool
	
	/// Should we show the trailing external link
	private var showExternalLink: Bool
	
	/// Create a Settings Row
	/// - Parameters:
	///   - icon: the icon for the row
	///   - iconBackground: the background for the icon
	///   - heading: the heading
	///   - subHeading: the sub heading
	///   - showChevron: Should we show the trailing chevron
	///   - showExternalLink: Should we show the trailing external link
	init(
		icon: Image? = nil,
		iconBackground: Color? = nil,
		heading: LocalizedStringKey,
		subHeading: LocalizedStringKey? = nil,
		showChevron: Bool = true,
		showExternalLink: Bool = false) {
		self.icon = icon
		self.iconBackground = iconBackground
		self.heading = heading
		self.subHeading = subHeading
		self.showChevron = showChevron
		self.showExternalLink = showExternalLink
		if showExternalLink {
			self.showChevron = false
		}
	}
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Icon {
			static let size: CGFloat = 24.0
			static let padding: CGFloat = 16.0
			static let cornerRadius: CGFloat = 6.0
		}
		enum Chevron {
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
	
		HStack(spacing: 0) {
			
			if let icon, let iconBackground {
				icon
					.foregroundStyle(theme.backgrounds.secondary)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
					.background(iconBackground)
					.cornerRadius(ViewTraits.Icon.cornerRadius)
					.padding(.trailing, ViewTraits.Icon.padding)
			}
			
			Text(heading)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
				.frame(minHeight: ViewTraits.Icon.size)
			
			Spacer()
			
			if let subHeading {
				Text(subHeading)
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.secondary)
					.frame(minHeight: ViewTraits.Icon.size)
			}
			
			if showChevron || showExternalLink {
				Image(showChevron ? ImageResource.Overview.chevronRight : ImageResource.Settings.arrowOutward)
					.foregroundStyle(theme.symbols.secondary)
					.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
					.accessibilityHidden(true)
			}
		}
		.padding(ViewTraits.General.padding)
	}
}
