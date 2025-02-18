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
	var contentInvert: Color { get }
	
	// MARK: - Icons -
	
	var symbolPrimary: Color { get }
	var symbolSecondary: Color { get }
	
	// MARK: - Lines -
	
	var borderPrimary: Color { get }
	var borderSecondary: Color { get }
	var borderTertiary: Color { get }
	
	// MARK: - Action Primary Default -
	
	var interactivePrimaryDefaultBackground: Color { get }
	var interactivePrimaryDefaultBackgroundHover: Color { get }
	var interactivePrimaryDefaultText: Color { get }
	
	// MARK: - Action Primary Critical -
	
	var interactivePrimaryCriticalBackground: Color { get }
	var interactivePrimaryCriticalBackgroundHover: Color { get }
	var interactivePrimaryCriticalText: Color { get }

	// MARK: - Action Secondary Default -

	var interactiveSecondaryDefaultBackground: Color { get }
	var interactiveSecondaryDefaultBackgroundHover: Color { get }
	var interactiveSecondaryDefaultText: Color { get }
	
	// MARK: - Action Secondary Critical -

	var interactiveSecondaryCriticalBackground: Color { get }
	var interactiveSecondaryCriticalBackgroundHover: Color { get }
	var interactiveSecondaryCriticalText: Color { get }
	
	// MARK: - Action Tertiary Default -
	
	var interactiveTertiaryDefaultText: Color { get }
	var interactiveTertiaryDefaultTextHover: Color { get }
	
	// MARK: - Action Tertiary Critical -
	
	var interactiveTertiaryCriticalText: Color { get }
	var interactiveTertiaryCriticalTextHover: Color { get }
	
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
	var lifestyle: Color { get }
}
