/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/**
 * Magic numbers for PDF generation
 */
public struct HealthExport {
	
	/// Magic numbers
	enum Constants {
		static let pageWidth: CGFloat = 595.28 // A4 Paper Size
		static let pageHeight: CGFloat = 841.89 // A4 Paper Size
		static let outerMargin: CGFloat = 28
		static let innerMargin: CGFloat = 16
		
		// The width and height we can draw on. (i.e. apply the outer margins)
		static let contentSize = CGSize(
			width: Constants.pageWidth - 2 * Constants.outerMargin,
			height: Constants.pageHeight - 2 * Constants.outerMargin
		)
	}
}
