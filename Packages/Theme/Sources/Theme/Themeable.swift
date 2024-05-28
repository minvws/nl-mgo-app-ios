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
	var linesTertiary: Color { get }
	var input: Color { get }
	
	// MARK: - Action Primary -
	
	var actionPrimaryBackground: Color { get }
	var actionPrimaryText: Color { get }
	var actionPrimaryBackgroundHover: Color { get }

	// MARK: - Action Secondary -

	var actionSecondaryBackground: Color { get }
	var actionSecondaryText: Color { get }
	var actionSecondaryBackgroundHover: Color { get }
	
	// MARK: - Action Tertiary -
	
	var actionTertiaryDefault: Color { get }
	var actionTertiaryHover: Color { get }
	
	// MARK: - Action Destructive -

	var actionDestructiveBackground: Color { get }
	var actionDestructiveBackgroundHover: Color { get }
	
	// MARK: - Notification -

	var notificationInformation: Color { get }
	var notificationSuccess: Color { get }
	var notificationWarning: Color { get }
	var notificationError: Color { get }

	// MARK: - Support -
	
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
	var rijksLint: Color { get }
}
