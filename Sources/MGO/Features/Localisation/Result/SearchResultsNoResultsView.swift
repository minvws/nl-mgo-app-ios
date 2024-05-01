/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class SearchResultNoResultsViewModel: ErrorViewModelProtocol {
	
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
	@Published var title: LocalizedStringKey = "searchresults_noresults_title"
	
	/// The main image of the error view
	@Published var image: ImageResource = ImageResource.defaultError
	
	/// The body of the error view
	@Published var body: LocalizedStringKey = "searchresults_noresults_body"
	
	/// The title of the action button
	@Published var button: LocalizedStringKey = "searchresults_noresults_button"
	
	/// The action when the user pressed the CTA
	@Published var action: () -> Void
	
	/// The view for the body
	/// - Returns: View
	@ViewBuilder func viewForBody() -> some View {
		
		Text(.init(String(format: String(localized: "searchresults_noresults_body"), arguments: [name, city])))
	
		VStack(alignment: .leading, spacing: 8) {
			
			Label(
				title: { Text("searchresults_noresults_reason_1") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
			
			Label(
				title: { Text("searchresults_noresults_reason_2") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
			
			Label(
				title: { Text("searchresults_noresults_reason_3") },
				icon: { Image(ImageResource.Localisation.arrowRight) }
			)
		}
	}
}

#Preview {
	NavigationView {
		ErrorView(
			viewModel: SearchResultNoResultsViewModel(
				city: "Roermond",
				name: "Tandarts Tandje Erbij",
				action: {}
			)
		)
	}
}
