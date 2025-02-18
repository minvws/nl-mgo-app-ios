/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
	@Published public var borderTertiary: Color = Color("borderTertiary", bundle: .module)

	// MARK: - Symbols -
	
	@Published public var symbolPrimary: Color = Color("symbolPrimary", bundle: .module)
	@Published public var symbolSecondary: Color = Color("symbolSecondary", bundle: .module)
	@Published public var symbolTertiary: Color = Color("symbolTertiary", bundle: .module)
	
	// MARK: - Sentiment -
	
	@Published public var sentimentInformation: Color = Color("sentimentInformation", bundle: .module)
	@Published public var sentimentPositive: Color = Color("sentimentPositive", bundle: .module)
	@Published public var sentimentWarning: Color = Color("sentimentWarning", bundle: .module)
	@Published public var sentimentCritical: Color = Color("sentimentCritical", bundle: .module)
	
	// MARK: - Interactive Primary Default -
	
	@Published public var interactivePrimaryDefaultBackground: Color = Color("interactivePrimaryDefaultBackground", bundle: .module)
	@Published public var interactivePrimaryDefaultBackgroundHover: Color = Color("interactivePrimaryDefaultBackgroundHover", bundle: .module)
	@Published public var interactivePrimaryDefaultText: Color = Color("interactivePrimaryDefaultText", bundle: .module)
	
	// MARK: - Interactive Primary Critical-
	
	@Published public var interactivePrimaryCriticalBackground: Color = Color("interactivePrimaryCriticalBackground", bundle: .module)
	@Published public var interactivePrimaryCriticalBackgroundHover: Color = Color("interactivePrimaryCriticalBackgroundHover", bundle: .module)
	@Published public var interactivePrimaryCriticalText: Color = Color("interactivePrimaryCriticalText", bundle: .module)

	// MARK: - Interactive Secondary Default -

	@Published public var interactiveSecondaryDefaultBackground: Color = Color("interactiveSecondaryDefaultBackground", bundle: .module)
	@Published public var interactiveSecondaryDefaultBackgroundHover: Color = Color("interactiveSecondaryDefaultBackgroundHover", bundle: .module)
	@Published public var interactiveSecondaryDefaultText: Color = Color("interactiveSecondaryDefaultText", bundle: .module)
	
	// MARK: - Interactive Secondary Critical -

	@Published public var interactiveSecondaryCriticalBackground: Color = Color("interactiveSecondaryCriticalBackground", bundle: .module)
	@Published public var interactiveSecondaryCriticalBackgroundHover: Color = Color("interactiveSecondaryCriticalBackgroundHover", bundle: .module)
	@Published public var interactiveSecondaryCriticalText: Color = Color("interactiveSecondaryCriticalText", bundle: .module)

	// MARK: - Interactive Tertiary Default -
	
	@Published public var interactiveTertiaryDefaultText: Color = Color("interactiveTertiaryDefaultText", bundle: .module)
	@Published public var interactiveTertiaryDefaultTextHover: Color = Color("interactiveTertiaryDefaultTextHover", bundle: .module)
	
	// MARK: - Interactive Tertiary Critical -
	
	@Published public var interactiveTertiaryCriticalText: Color = Color("interactiveTertiaryCriticalText", bundle: .module)
	@Published public var interactiveTertiaryCriticalTextHover: Color = Color("interactiveTertiaryCriticalTextHover", bundle: .module)
	
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
