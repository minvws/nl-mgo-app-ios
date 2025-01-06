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
	
	var strokesPrimary: Color { get }
	var strokesSecondary: Color { get }
	var strokesTertiary: Color { get }
	
	// MARK: - Action Primary Default -
	
	var actionPrimaryDefaultBackground: Color { get }
	var actionPrimaryDefaultBackgroundHover: Color { get }
	var actionPrimaryDefaultText: Color { get }
	
	// MARK: - Action Primary Critical -
	
	var actionPrimaryCriticalBackground: Color { get }
	var actionPrimaryCriticalBackgroundHover: Color { get }
	var actionPrimaryCriticalText: Color { get }

	// MARK: - Action Secondary Default -

	var actionSecondaryDefaultBackground: Color { get }
	var actionSecondaryDefaultBackgroundHover: Color { get }
	var actionSecondaryDefaultText: Color { get }
	
	// MARK: - Action Secondary Critical -

	var actionSecondaryCriticalBackground: Color { get }
	var actionSecondaryCriticalBackgroundHover: Color { get }
	var actionSecondaryCriticalText: Color { get }
	
	// MARK: - Action Tertiary Default -
	
	var actionTertiaryDefaultText: Color { get }
	var actionTertiaryDefaultTextHover: Color { get }
	
	// MARK: - Action Tertiary Critical -
	
	var actionTertiaryCriticalText: Color { get }
	var actionTertiaryCriticalTextHover: Color { get }
	
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
	var verloskundige: Color { get }
	var overige: Color { get }
	var rijksLint: Color { get }
	var rivm: Color { get }
	var ggd: Color { get }
	var revalidatie: Color { get }
	var gegevens: Color { get }
}
