/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// The state of a category button
enum CategoryButtonState: String, CaseIterable {
	
	/// There is data from the server that is available for display
	case loaded
	
	/// Loading the data from the server
	case loading
	
	/// No data available. (could be a network failure, could just be no data in this category)
	case empty
	
	/// This category is not yet implemented.
	case notAvailable
}
