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
	//
	//	static var contentPrimary: Color { get }
	//
	//	static var contentSecondary: Color { get }
	//
	//	static var contentTertiary: Color { get }
	//
	// MARK: - Icons -
	//
	//	static var iconsPrimary: Color { get }
	//
	//	static var iconSecondary: Color { get }
	//
	// MARK: - Lines -
	//
	//	static var linesPrimary: Color { get }
	//
	//	static var linesSecondary: Color { get }
	//
	//	static var actionBorder: Color { get }
	//
	// MARK: - Support -
	//
	//	static var actionPrimary: Color { get }
	//
	//	static var actionSecondary: Color { get }
	//
	//	static var actionTertiary: Color { get }
	//
	//	static var rijksLint: Color { get }
	//
	//	static var notificationSuccess: Color { get }
	//
	//	static var notificationWarning: Color { get }
	//
	//	static var notificationError: Color { get }
	//
	//	static var apotheek: Color { get }
	//
	//	static var ziekenhuis: Color { get }
	//
	//	static var huisarts: Color { get }
	//
	//	static var tandarts: Color { get }
	//
	//	static var ggz: Color { get }
	//
	//	static var fysiotherapeut: Color { get }
	//
	//	static var verpleeghuis: Color { get }
	//
	//	static var thuiszorg: Color { get }
	//
	//	static var kliniek: Color { get }
	//
	//	static var overige: Color { get }
	
}
