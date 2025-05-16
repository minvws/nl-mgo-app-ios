/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class OrganizationListEmptyViewModel: ErrorViewModelProtocol {
	
	/// The name we searched on
	private var name: String
	
	/// The city we searched on
	private var city: String
	
	/// Initializer
	/// - Parameters:
	///   - city: the city we searched on
	///   - name: the name we searched on
	///   - action: completion handler when the user presses the CTA  button
	init(
		city: String,
		name: String,
		action: @escaping () -> Void) {
	
		self.city = city
		self.name = name
		self.action = action
	}
	
	/// The title of the error view
	@Published var title: LocalizedStringKey = "organization_search.no_results_found_heading"
	
	/// The main image of the error view
	@Published var image: ImageResource = ImageResource.Woman.womanOnCouchExclamation
	
	/// The body of the error view
	@Published var body: LocalizedStringKey = "organization_search.no_results_found_subheading"
	
	/// The title of the action button
	@Published var button: LocalizedStringKey = "common.search_again"
	
	/// The action when the user pressed the CTA
	@Published var action: () -> Void
	
	/// The view for the body
	/// - Returns: View
	@ViewBuilder func viewForBody() -> some View {
		
		Text(.init(String(format: String(localized: "organization_search.no_results_found_subheading"), arguments: [name, city])))
	
		VStack(alignment: .leading, spacing: 8) {
			
			Label(
				title: { Text("organization_search.search_hint_1") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
			
			Label(
				title: { Text("organization_search.search_hint_2") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
			
			Label(
				title: { Text("organization_search.search_hint_3") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
		}
	}
}

#Preview {
	NavigationView {
		ErrorView(
			viewModel: OrganizationListEmptyViewModel(
				city: "Roermond",
				name: "Tandarts Tandje Erbij",
				action: {}
			)
		)
	}
}
