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
	@Published public var contentTertiary: Color = Color("contentTertiary", bundle: .module)
	
	// MARK: - Icons -
	
	@Published public var iconsPrimary: Color = Color("iconsPrimary", bundle: .module)
	@Published public var iconsSecondary: Color = Color("iconsSecondary", bundle: .module)
	
	// MARK: - Strokes -
	
	@Published public var strokesPrimary: Color = Color("strokesPrimary", bundle: .module)
	@Published public var strokesSecondary: Color = Color("strokesSecondary", bundle: .module)
	@Published public var strokesTertiary: Color = Color("strokesTertiary", bundle: .module)
	
	// MARK: - Action Primary Default -
	
	@Published public var actionPrimaryDefaultBackground: Color = Color("actionPrimaryDefaultBackground", bundle: .module)
	@Published public var actionPrimaryDefaultBackgroundHover: Color = Color("actionPrimaryDefaultBackgroundHover", bundle: .module)
	@Published public var actionPrimaryDefaultText: Color = Color("actionPrimaryDefaultText", bundle: .module)
	
	// MARK: - Action Primary Critical-
	
	@Published public var actionPrimaryCriticalBackground: Color = Color("actionPrimaryCriticalBackground", bundle: .module)
	@Published public var actionPrimaryCriticalBackgroundHover: Color = Color("actionPrimaryCriticalBackgroundHover", bundle: .module)
	@Published public var actionPrimaryCriticalText: Color = Color("actionPrimaryCriticalText", bundle: .module)

	// MARK: - Action Secondary Default -

	@Published public var actionSecondaryDefaultBackground: Color = Color("actionSecondaryDefaultBackground", bundle: .module)
	@Published public var actionSecondaryDefaultBackgroundHover: Color = Color("actionSecondaryDefaultBackgroundHover", bundle: .module)
	@Published public var actionSecondaryDefaultText: Color = Color("actionSecondaryDefaultText", bundle: .module)
	
	// MARK: - Action Secondary Critical -

	@Published public var actionSecondaryCriticalBackground: Color = Color("actionSecondaryCriticalBackground", bundle: .module)
	@Published public var actionSecondaryCriticalBackgroundHover: Color = Color("actionSecondaryCriticalBackgroundHover", bundle: .module)
	@Published public var actionSecondaryCriticalText: Color = Color("actionSecondaryCriticalText", bundle: .module)

	// MARK: - Action Tertiary Default -
	
	@Published public var actionTertiaryDefaultText: Color = Color("actionTertiaryDefaultText", bundle: .module)
	@Published public var actionTertiaryDefaultTextHover: Color = Color("actionTertiaryDefaultTextHover", bundle: .module)
	
	// MARK: - Action Tertiary Critical -
	
	@Published public var actionTertiaryCriticalText: Color = Color("actionTertiaryCriticalText", bundle: .module)
	@Published public var actionTertiaryCriticalTextHover: Color = Color("actionTertiaryCriticalTextHover", bundle: .module)
	
	// MARK: - Notification -
	
	@Published public var notificationInformation: Color = Color("notificationInformation", bundle: .module)
	@Published public var notificationSuccess: Color = Color("notificationSuccess", bundle: .module)
	@Published public var notificationWarning: Color = Color("notificationWarning", bundle: .module)
	@Published public var notificationError: Color = Color("notificationError", bundle: .module)
	
	// MARK: - Support -
	
	@Published public var apotheek: Color = Color("apotheek", bundle: .module)
	@Published public var ziekenhuis: Color = Color("ziekenhuis", bundle: .module)
	@Published public var huisarts: Color = Color("huisarts", bundle: .module)
	@Published public var tandarts: Color = Color("tandarts", bundle: .module)
	@Published public var ggz: Color = Color("ggz", bundle: .module)
	@Published public var fysiotherapeut: Color = Color("fysiotherapeut", bundle: .module)
	@Published public var verpleeghuis: Color = Color("verpleeghuis", bundle: .module)
	@Published public var thuiszorg: Color = Color("thuiszorg", bundle: .module)
	@Published public var kliniek: Color = Color("kliniek", bundle: .module)
	@Published public var verloskundige: Color = Color("verloskundige", bundle: .module)
	@Published public var overige: Color = Color("overige", bundle: .module)
	@Published public var rijksLint: Color = Color("rijkslint", bundle: .module)
	@Published public var rivm: Color = Color("rivm", bundle: .module)
	@Published public var ggd: Color = Color("ggd", bundle: .module)
	@Published public var revalidatie: Color = Color("revalidatie", bundle: .module)
	@Published public var gegevens: Color = Color("gegevens", bundle: .module)
}
