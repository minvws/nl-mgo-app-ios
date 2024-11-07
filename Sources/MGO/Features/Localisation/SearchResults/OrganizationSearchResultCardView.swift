/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum OrganizationSearchResultCardState {
	case regular
	case selected
	case notParticipating
	case notImplemented
	
	var accessibilityLabel: String.LocalizationValue {
		switch self {
			case .regular: return "add_organization.add_voiceover"
			case .selected: return "add_organization.view_voiceover"
			case .notParticipating, .notImplemented: return "add_organization.view_voiceover"
		}
	}
}

struct OrganizationSearchResultCardView: View {
	
	/// The search result to display
	var model: OrganizationSearchResult
	
	/// The state of the card
	var state: OrganizationSearchResultCardState
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 12
			static let cornerRadius: CGFloat = 10
		}
		enum Title {
			static let padding: CGFloat = 4
		}
		enum Box {
			static let inset: CGFloat = 0.5
		}
		enum Selected {
			static let spacing: CGFloat = 4.0
			static let padding: CGFloat = 8.0
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
		
		HStack {
			
			VStack(alignment: .leading, spacing: 0) {
				
				Text(model.name)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.multilineTextAlignment(.leading)
					.padding(.bottom, ViewTraits.Title.padding)
				
				if let address = model.address, address.isNotEmpty {
					Text(address)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentSecondary)
				}
				
				if model.postalCode != nil || model.city != nil {
					HStack {
						if let postalCode = model.postalCode, postalCode.isNotEmpty {
							Text(postalCode)
						}
						if let city = model.city, city.isNotEmpty {
							Text(city)
						}
					}
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentSecondary)
				}
				if state != .regular {
					organizationStatusView(state)
				}
			}
			
			Spacer()
			
			if state == .regular {
				Image(ImageResource.Localisation.Icon.add)
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefaultText : theme.actionPrimaryDefaultBackground)
						.font(Font.title2.bold())
			}

		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.when(state != .regular, transform: { view in
			view.background(theme.backgroundSecondary.opacity(0.50))
		})
		.when(state == .regular, transform: { view in
			view
				.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
		})
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius))
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			perform?()
		}
	}
	
	/// The view for the status of the organization
	/// - Parameter state: state
	/// - Returns: status view
	@ViewBuilder func organizationStatusView(_ state: OrganizationSearchResultCardState) -> some View {
		switch state {
			case .regular: EmptyView()
				
			case .notParticipating, .notImplemented, .selected:
				HStack(alignment: .center, spacing: ViewTraits.Selected.spacing) {
					if case .notParticipating = state {
						Image(ImageResource.Localisation.Icon.error)
							
						Text("add_organization.not_participating")
							.foregroundStyle(theme.notificationError)
					}
					if case .notImplemented
						= state {
						
						Image(ImageResource.Localisation.Icon.info)
						Text("add_organization.not_implemented")
							.foregroundStyle(theme.notificationInformation)
					}
					if case .selected
						= state {
						
						Image(ImageResource.Localisation.Icon.checkCircle)
						Text("add_organization.already_added")
							.foregroundStyle(theme.notificationSuccess)
					}
				}
				.rijksoverheidStyle(font: .bold, style: .body)
				.multilineTextAlignment(.leading)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, ViewTraits.Selected.padding)
				.accessibilityElement(children: .combine)
		}
	}
}

#Preview {

	VStack(spacing: 8) {
		
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .regular
		)
	
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .selected
		)
		
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .notParticipating
		)
		
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: nil,
				postalCode: "1234AB"
			),
			state: .notImplemented
		)
	}
	.padding(16)
	.background(Theme().backgroundPrimary)
}
