/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum OrganizationListCardState: Equatable {
	case regular
	case selected
	case notParticipating
	case automatic(isSelected: Bool)
	
	var accessibilityLabel: String.LocalizationValue {
		switch self {
			case .regular, .automatic: return "add_organization.add_voiceover"
			case .selected: return "add_organization.view_voiceover"
			case .notParticipating: return "add_organization.view_voiceover"
		}
	}
}

struct OrganizationListCardView: View {
	
	/// The search result to display
	var model: OrganizationDisplayModel
	
	/// The state of the card
	var state: OrganizationListCardState
	
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
			static let padding: CGFloat = 16
			static let cornerRadius: CGFloat = 10
		}
		enum Title {
			static let padding: CGFloat = 4
		}
		enum Box {
			static let inset: CGFloat = 0.5
			static let opacity: Double = 0.50
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
					.fixedSize(horizontal: false, vertical: true)
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
					.foregroundStyle(colorScheme == .dark ? theme.interactionTertiaryDefaultText : theme.interactionPrimaryDefaultBackground)
					.font(Font.title2.bold())
			}
			if case let .automatic(isSelected) = state {
				if isSelected {
					Image(ImageResource.Localisation.Icon.checked)
				} else {
					Image(ImageResource.Localisation.Icon.circle)
						.foregroundStyle(theme.symbolPrimary)
				}
			}
		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.when(state == .notParticipating || state == .selected, transform: { view in
			view.background(theme.backgroundSecondary.opacity(ViewTraits.Box.opacity))
		})
		.when(state != .notParticipating && state != .selected, transform: { view in
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
	@ViewBuilder func organizationStatusView(_ state: OrganizationListCardState) -> some View {
		switch state {
			case .regular, .automatic: EmptyView()
				
			case .notParticipating, .selected:
				HStack(alignment: .center, spacing: ViewTraits.Selected.spacing) {
					if case .notParticipating = state {
						
						Image(ImageResource.Localisation.Icon.info)
						Text("add_organization.not_participating")
							.foregroundStyle(theme.sentimentInformation)
					}
					if case .selected
						= state {
							
						Image(ImageResource.Localisation.Icon.checkCircle)
						Text("add_organization.already_added")
							.foregroundStyle(theme.sentimentPositive)
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
		
		OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .regular
		)
	
		OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .selected
		)
		
		OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .notParticipating
		)
		OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .automatic(isSelected: true)
		)
		OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .automatic(isSelected: false)
		)
	}
	.padding(16)
	.background(Theme().backgroundPrimary)
}
