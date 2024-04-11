/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public protocol Themeable: ObservableObject {
	
	// MARK: - Background -
	
	var backgroundPrimary: Color { get }
	
	var backgroundSecondary: Color { get }
	
	var backgroundTertiary: Color { get }
	
	// MARK: - Content -
	
	var contentPrimary: Color { get }
	
	var contentSecondary: Color { get }
	
	var contentTertiary: Color { get }
	
	// MARK: - Icons -
	
	var iconsPrimary: Color { get }
	
	var iconsSecondary: Color { get }
	
	// MARK: - Lines -
	
	var linesPrimary: Color { get }
	
	var linesSecondary: Color { get }
	
	var actionBorder: Color { get }
	
	// MARK: - Support -
	
	var actionPrimary: Color { get }
	
	var actionSecondary: Color { get }
	
	var actionTertiary: Color { get }
	
	var rijksLint: Color { get }
	
	var notificationSuccess: Color { get }
	
	var notificationWarning: Color { get }
	
	var notificationError: Color { get }
	
	var apotheek: Color { get }
	
	var ziekenhuis: Color { get }
	
	var huisarts: Color { get }
	
	var tandarts: Color { get }
	
	var ggz: Color { get }
	
	var fysiotherapeut: Color { get }
	
	var verpleeghuis: Color { get }
	
	var thuiszorg: Color { get }
	
	var kliniek: Color { get }
	
	var overige: Color { get }
}
