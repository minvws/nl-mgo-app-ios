/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class Theme: Themeable {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
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
	@Published public var interactionPrimaryDefaultBackgroundHover: Color = Color("interactionPrimaryDefaultBackgroundHover", bundle: .module)
	@Published public var interactionPrimaryDefaultText: Color = Color("interactionPrimaryDefaultText", bundle: .module)
	
	// MARK: - interaction Primary Critical-
	
	@Published public var interactionPrimaryCriticalBackground: Color = Color("interactionPrimaryCriticalBackground", bundle: .module)
	@Published public var interactionPrimaryCriticalBackgroundHover: Color = Color("interactionPrimaryCriticalBackgroundHover", bundle: .module)
	@Published public var interactionPrimaryCriticalText: Color = Color("interactionPrimaryCriticalText", bundle: .module)

	// MARK: - interaction Secondary Default -

	@Published public var interactionSecondaryDefaultBackground: Color = Color("interactionSecondaryDefaultBackground", bundle: .module)
	@Published public var interactionSecondaryDefaultBackgroundHover: Color = Color("interactionSecondaryDefaultBackgroundHover", bundle: .module)
	@Published public var interactionSecondaryDefaultText: Color = Color("interactionSecondaryDefaultText", bundle: .module)
	
	// MARK: - interaction Secondary Critical -

	@Published public var interactionSecondaryCriticalBackground: Color = Color("interactionSecondaryCriticalBackground", bundle: .module)
	@Published public var interactionSecondaryCriticalBackgroundHover: Color = Color("interactionSecondaryCriticalBackgroundHover", bundle: .module)
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
