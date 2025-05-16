/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	var contentInvert: Color { get }
	
	// MARK: - Icons -
	
	var symbolPrimary: Color { get }
	var symbolSecondary: Color { get }
	
	// MARK: - Lines -
	
	var borderPrimary: Color { get }
	var borderSecondary: Color { get }
	
	// MARK: - Action Primary Default -
	
	var interactionPrimaryDefaultBackground: Color { get }
	var interactionPrimaryDefaultBackgroundHover: Color { get }
	var interactionPrimaryDefaultText: Color { get }
	
	// MARK: - Action Primary Critical -
	
	var interactionPrimaryCriticalBackground: Color { get }
	var interactionPrimaryCriticalBackgroundHover: Color { get }
	var interactionPrimaryCriticalText: Color { get }

	// MARK: - Action Secondary Default -

	var interactionSecondaryDefaultBackground: Color { get }
	var interactionSecondaryDefaultBackgroundHover: Color { get }
	var interactionSecondaryDefaultText: Color { get }
	
	// MARK: - Action Secondary Critical -

	var interactionSecondaryCriticalBackground: Color { get }
	var interactionSecondaryCriticalBackgroundHover: Color { get }
	var interactionSecondaryCriticalText: Color { get }
	
	// MARK: - Action Tertiary Default -
	
	var interactionTertiaryDefaultText: Color { get }
	var interactionTertiaryDefaultTextHover: Color { get }
	
	// MARK: - Action Tertiary Critical -
	
	var interactionTertiaryCriticalText: Color { get }
	var interactionTertiaryCriticalTextHover: Color { get }
	
	// MARK: - Notification -

	var sentimentInformation: Color { get }
	var sentimentPositive: Color { get }
	var sentimentWarning: Color { get }
	var sentimentCritical: Color { get }

	// MARK: - Support -
	
	var medication: Color { get }
	var treatment: Color { get }
	var contacts: Color { get }
	var laboratory: Color { get }
	var functional: Color { get }
	var device: Color { get }
	var vitals: Color { get }
	var documents: Color { get }
	var allergies: Color { get }
	var problems: Color { get }
	var personal: Color { get }
	var rijksLint: Color { get }
	var warning: Color { get }
	var payer: Color { get }
	var vaccinations: Color { get }
	var procedures: Color { get }
	var lifestyle: Color { get }
}
