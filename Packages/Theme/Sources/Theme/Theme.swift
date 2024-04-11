/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public class Theme: Themeable {
	
	public init() { }
	
	@Published public var backgroundPrimary: Color = Color("backgroundPrimary", bundle: .module)
	
	@Published public var backgroundSecondary: Color = Color("backgroundSecondary", bundle: .module)
	
	@Published public var backgroundTertiary: Color = Color("backgroundTertiary", bundle: .module)
	
}
