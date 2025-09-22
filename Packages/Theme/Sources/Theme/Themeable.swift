/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct Colors {
	
	public struct Backgrounds {
		public let primary: Color
		public let secondary: Color
		public let tertiary: Color
	}
	
	public struct Labels {
		public let primary: Color
		public let secondary: Color
		public let invert: Color
		public let vibrant: Color
	}
	
	public struct Separators {
		public let primary: Color
		public let secondary: Color
		public let invert: Color
	}
	
	public struct Symbols {
		public let primary: Color
		public let secondary: Color
		public let tertiary: Color
	}
	
	public struct States {
		public let informative: Color
		public let positive: Color
		public let warning: Color
		public let critical: Color
	}
	
	public struct Categories {
		public let rijkslint: Color
		public let medication: Color
		public let treatment: Color
		public let contacts: Color
		public let laboratory: Color
		public let functional: Color
		public let device: Color
		public let vitals: Color
		public let documents: Color
		public let vaccinations: Color
		public let allergies: Color
		public let problems: Color
		public let personal: Color
		public let warning: Color
		public let payer: Color
		public let procedures: Color
		public let lifestyle: Color
		public let plan: Color
	}
	
	public struct Actions {
		
		public struct Primary {
			public let background: Color
			public let text: Color
		}
		
		public struct Secondary {
			public let background: Color
			public let text: Color
		}
		
		public struct Tertiary {
			public let text: Color
			public let hover: Color
		}
		
		public let primary: Actions.Primary
		public let secondary: Actions.Secondary
		public let tertiary: Actions.Tertiary
	}
}
public protocol Themeable: ObservableObject {
	
	// MARK: - Background -
	
	var backgrounds: Colors.Backgrounds { get }
	
	// MARK: - Labels -
	
	var labels: Colors.Labels { get }
	
	// MARK: - Separators -
	
	var separators: Colors.Separators { get }
	var borderPrimary: Color { get }
	var borderSecondary: Color { get }
	
	// MARK: - Symbols -
	
	var symbols: Colors.Symbols { get }
	var symbolPrimary: Color { get }
	var symbolSecondary: Color { get }
	
	// MARK: - States -
	
	var states: Colors.States { get }
	var sentimentInformation: Color { get }
	var sentimentPositive: Color { get }
	var sentimentWarning: Color { get }
	var sentimentCritical: Color { get }

	// MARK: - Categories -
	
	var categories: Colors.Categories { get }
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
	
	// MARK: - Actions -
	var actions: Colors.Actions { get }
	
	// MARK: - Action Primary Default -
	
	var interactionPrimaryDefaultBackground: Color { get }
	var interactionPrimaryDefaultText: Color { get }
	
	// MARK: - Action Primary Critical -
	
	var interactionPrimaryCriticalBackground: Color { get }
	var interactionPrimaryCriticalText: Color { get }
	
	// MARK: - Action Secondary Default -
	
	var interactionSecondaryDefaultBackground: Color { get }
	var interactionSecondaryDefaultText: Color { get }
	
	// MARK: - Action Secondary Critical -
	
	var interactionSecondaryCriticalBackground: Color { get }
	var interactionSecondaryCriticalText: Color { get }
	
	// MARK: - Action Tertiary Default -
	
	var interactionTertiaryDefaultText: Color { get }
	var interactionTertiaryDefaultTextHover: Color { get }
	
	// MARK: - Action Tertiary Critical -
	
	var interactionTertiaryCriticalText: Color { get }
	var interactionTertiaryCriticalTextHover: Color { get }
	
}
