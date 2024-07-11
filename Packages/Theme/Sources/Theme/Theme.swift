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
	
	// MARK: - Lines -
	
	@Published public var linesPrimary: Color = Color("linesPrimary", bundle: .module)
	@Published public var linesSecondary: Color = Color("linesSecondary", bundle: .module)
	@Published public var linesTertiary: Color = Color("linesTertiary", bundle: .module)
	@Published public var input: Color = Color("input", bundle: .module)
	
	// MARK: - Action Primary -
	
	@Published public var actionPrimaryBackground: Color = Color("actionPrimaryBackground", bundle: .module)
	@Published public var actionPrimaryText: Color = Color("actionPrimaryText", bundle: .module)
	@Published public var actionPrimaryBackgroundHover: Color = Color("actionPrimaryBackgroundHover", bundle: .module)

	// MARK: - Action Secondary -

	@Published public var actionSecondaryBackground: Color = Color("actionSecondaryBackground", bundle: .module)
	@Published public var actionSecondaryText: Color = Color("actionSecondaryText", bundle: .module)
	@Published public var actionSecondaryBackgroundHover: Color = Color("actionSecondaryBackgroundHover", bundle: .module)

	// MARK: - Action Tertiary -
	
	@Published public var actionTertiaryDefault: Color = Color("actionTertiaryDefault", bundle: .module)
	@Published public var actionTertiaryHover: Color = Color("actionTertiaryHover", bundle: .module)
	
	// MARK: - Action Destructive -

	@Published public var actionDestructiveBackground: Color = Color("actionDestructiveBackground", bundle: .module)
	@Published public var actionDestructiveBackgroundHover: Color = Color("actionDestructiveBackgoundHover", bundle: .module)
	@Published public var actionDestructiveText: Color = Color("actionDestructiveText", bundle: .module)
	
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
	@Published public var overige: Color = Color("overige", bundle: .module)
	@Published public var rijksLint: Color = Color("rijkslint", bundle: .module)
}
