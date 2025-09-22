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
		primary: Color("separatorsPrimary", bundle: .main),
		secondary: Color("separatorsSecondary", bundle: .main),
		invert: Color("separatorsInvert", bundle: .main)
	)
	
	@Published public var symbols = Colors.Symbols(
		primary: Color("symbolsPrimary", bundle: .main),
		secondary: Color("symbolsSecondary", bundle: .main),
		tertiary: Color("symbolsTertiary", bundle: .main)
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
		payer: Color("categoriesPayer", bundle: .module),
		procedures: Color("categoriesProcedures", bundle: .module),
		lifestyle: Color("categoriesLifestyle", bundle: .module),
		plan: Color("categoriesPlan", bundle: .module)
	)
	
	@Published public var actions: Colors.Actions = Colors.Actions(
		primary: Colors.Actions.Primary(
			background: Color("actionsPrimaryBackground", bundle: .module),
			text: Color("actionsPrimaryText", bundle: .module)
		),
		secondary: Colors.Actions.Secondary(
			background: Color("actionsSecondaryBackground", bundle: .module),
			text: Color("actionsSecondaryText", bundle: .module)
		),
		tertiary: Colors.Actions.Tertiary(
			text: Color("actionsTertiaryText", bundle: .module),
			hover: Color("actionsTertiaryHover", bundle: .module)
		)
	)
	
	// MARK: - Background -
	
	@Published public var backgroundPrimary: Color = Color("backgroundPrimary", bundle: .module)
	@Published public var backgroundSecondary: Color = Color("backgroundSecondary", bundle: .module)
	@Published public var backgroundTertiary: Color = Color("backgroundTertiary", bundle: .module)
	
	// MARK: - Content -
	
	@Published public var contentPrimary: Color = Color("contentPrimary", bundle: .module)
	@Published public var contentSecondary: Color = Color("contentSecondary", bundle: .module)
	@Published public var contentInvert: Color = Color("contentInvert", bundle: .module)
	
	// MARK: - Border -
	
	@Published public var borderPrimary: Color = Color("borderPrimary", bundle: .module)
	@Published public var borderSecondary: Color = Color("borderSecondary", bundle: .module)

	// MARK: - Symbols -
	
	@Published public var symbolPrimary: Color = Color("symbolPrimary", bundle: .module)
	@Published public var symbolSecondary: Color = Color("symbolSecondary", bundle: .module)
	@Published public var symbolTertiary: Color = Color("symbolTertiary", bundle: .module)
	
	// MARK: - Sentiment -
	
	@Published public var sentimentInformation: Color = Color("sentimentInformation", bundle: .module)
	@Published public var sentimentPositive: Color = Color("sentimentPositive", bundle: .module)
	@Published public var sentimentWarning: Color = Color("sentimentWarning", bundle: .module)
	@Published public var sentimentCritical: Color = Color("sentimentCritical", bundle: .module)
	
	// MARK: - interaction Primary Default -
	
	@Published public var interactionPrimaryDefaultBackground: Color = Color("interactionPrimaryDefaultBackground", bundle: .module)
	@Published public var interactionPrimaryDefaultText: Color = Color("interactionPrimaryDefaultText", bundle: .module)
	
	// MARK: - interaction Primary Critical-
	
	@Published public var interactionPrimaryCriticalBackground: Color = Color("interactionPrimaryCriticalBackground", bundle: .module)
	@Published public var interactionPrimaryCriticalText: Color = Color("interactionPrimaryCriticalText", bundle: .module)

	// MARK: - interaction Secondary Default -

	@Published public var interactionSecondaryDefaultBackground: Color = Color("interactionSecondaryDefaultBackground", bundle: .module)
	@Published public var interactionSecondaryDefaultText: Color = Color("interactionSecondaryDefaultText", bundle: .module)
	
	// MARK: - interaction Secondary Critical -

	@Published public var interactionSecondaryCriticalBackground: Color = Color("interactionSecondaryCriticalBackground", bundle: .module)
	@Published public var interactionSecondaryCriticalText: Color = Color("interactionSecondaryCriticalText", bundle: .module)

	// MARK: - interaction Tertiary Default -
	
	@Published public var interactionTertiaryDefaultText: Color = Color("interactionTertiaryDefaultText", bundle: .module)
	@Published public var interactionTertiaryDefaultTextHover: Color = Color("interactionTertiaryDefaultTextHover", bundle: .module)
	
	// MARK: - interaction Tertiary Critical -
	
	@Published public var interactionTertiaryCriticalText: Color = Color("interactionTertiaryCriticalText", bundle: .module)
	@Published public var interactionTertiaryCriticalTextHover: Color = Color("interactionTertiaryCriticalTextHover", bundle: .module)
	
	// MARK: - Support -
	
	@Published public var medication: Color = Color("medication", bundle: .module)
	@Published public var treatment: Color = Color("treatment", bundle: .module)
	@Published public var contacts: Color = Color("contacts", bundle: .module)
	@Published public var laboratory: Color = Color("laboratory", bundle: .module)
	@Published public var functional: Color = Color("functional", bundle: .module)
	@Published public var device: Color = Color("device", bundle: .module)
	@Published public var vitals: Color = Color("vitals", bundle: .module)
	@Published public var documents: Color = Color("documents", bundle: .module)
	@Published public var allergies: Color = Color("allergies", bundle: .module)
	@Published public var problems: Color = Color("problems", bundle: .module)
	@Published public var personal: Color = Color("personal", bundle: .module)
	@Published public var rijksLint: Color = Color("rijkslint", bundle: .module)
	@Published public var warning: Color = Color("warning", bundle: .module)
	@Published public var payer: Color = Color("payer", bundle: .module)
	@Published public var vaccinations: Color = Color("vaccinations", bundle: .module)
	@Published public var procedures: Color = Color("procedures", bundle: .module)
	@Published public var lifestyle: Color = Color("lifestyle", bundle: .module)
}
