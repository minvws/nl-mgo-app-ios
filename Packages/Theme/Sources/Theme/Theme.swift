/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class Theme: Themeable {
	
	public init() { }
	
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
	@Published public var actionBorder: Color = Color("actionBorder", bundle: .module)
	
	// MARK: - Action -
	
	@Published public var actionPrimary: Color = Color("actionPrimary", bundle: .module)
	@Published public var actionSecondary: Color = Color("actionSecondary", bundle: .module)
	@Published public var actionTertiary: Color = Color("actionTertiary", bundle: .module)
	@Published public var actionPrimaryText: Color = Color("actionPrimaryText", bundle: .module)
	@Published public var actionSecondaryText: Color = Color("actionSecondaryText", bundle: .module)
	@Published public var actionPrimaryHover: Color = Color("actionPrimaryHover", bundle: .module)
	@Published public var actionSecondaryHover: Color = Color("actionSecondaryHover", bundle: .module)
	
	// MARK: - Support -
	
	@Published public var rijksLint: Color = Color("rijkslint", bundle: .module)
	@Published public var notificationSuccess: Color = Color("notificationSuccess", bundle: .module)
	@Published public var notificationWarning: Color = Color("notificationWarning", bundle: .module)
	@Published public var notificationError: Color = Color("notificationError", bundle: .module)
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
}
