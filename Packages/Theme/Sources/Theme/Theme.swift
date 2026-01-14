/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public final class Theme: Themeable {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	@Published public var backgrounds = Colors.Backgrounds(
		primary: Color("backgroundsPrimary", bundle: .module),
		secondary: Color("backgroundsSecondary", bundle: .module),
		tertiary: Color("backgroundsTertiary", bundle: .module)
	)

	@Published public var labels = Colors.Labels(
		primary: Color("labelsPrimary", bundle: .module),
		secondary: Color("labelsSecondary", bundle: .module),
		invert: Color("labelsInvert", bundle: .module),
		vibrant: Color("labelsVibrant", bundle: .module)
	)
	
	@Published public var separators = Colors.Separators(
		primary: Color("separatorsPrimary", bundle: .module),
		secondary: Color("separatorsSecondary", bundle: .module),
		invert: Color("separatorsInvert", bundle: .module)
	)
	
	@Published public var symbols = Colors.Symbols(
		primary: Color("symbolsPrimary", bundle: .module),
		secondary: Color("symbolsSecondary", bundle: .module),
		tertiary: Color("symbolsTertiary", bundle: .module)
	)
	
	@Published public var states = Colors.States(
		informative: Color("statesInformation", bundle: .module),
		positive: Color("statesPositive", bundle: .module),
		warning: Color("statesWarning", bundle: .module),
		critical: Color("statesCritical", bundle: .module)
	)
	
	@Published public var categories: Colors.Categories = Colors.Categories(
		rijkslint: Color("categoriesRijkslint", bundle: .module),
		medication: Color("categoriesMedication", bundle: .module),
		treatment: Color("categoriesTreatment", bundle: .module),
		contacts: Color("categoriesContacts", bundle: .module),
		laboratory: Color("categoriesLaboratory", bundle: .module),
		functional: Color("categoriesFunctional", bundle: .module),
		device: Color("categoriesDevice", bundle: .module),
		vitals: Color("categoriesVitals", bundle: .module),
		documents: Color("categoriesDocuments", bundle: .module),
		vaccinations: Color("categoriesVaccinations", bundle: .module),
		allergies: Color("categoriesAllergies", bundle: .module),
		problems: Color("categoriesProblems", bundle: .module),
		personal: Color("categoriesPersonal", bundle: .module),
		warning: Color("categoriesWarning", bundle: .module),
		providers: Color("categoriesProvider", bundle: .module),
		procedures: Color("categoriesProcedures", bundle: .module),
		lifestyle: Color("categoriesLifestyle", bundle: .module),
		plan: Color("categoriesPlan", bundle: .module)
	)
	
	@Published public var actions: Colors.Actions = Colors.Actions(
		solid: Colors.Actions.Solid(
			background: Color("actionsPrimaryBackground", bundle: .module),
			text: Color("actionsPrimaryText", bundle: .module)
		),
		tonal: Colors.Actions.Tonal(
			background: Color("actionsSecondaryBackground", bundle: .module),
			text: Color("actionsSecondaryText", bundle: .module)
		),
		ghost: Colors.Actions.Ghost(
			text: Color("actionsTertiaryText", bundle: .module),
			hover: Color("actionsTertiaryHover", bundle: .module)
		)
	)
}
