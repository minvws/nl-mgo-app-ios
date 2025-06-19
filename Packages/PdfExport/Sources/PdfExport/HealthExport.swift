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
	public enum Constants {
		static public let pageWidth: CGFloat = 595.28 // A4 Paper Size
		static public let pageHeight: CGFloat = 841.89 // A4 Paper Size
		static public let outerMargin: CGFloat = 28
		static public let innerMargin: CGFloat = 16
		
		// The width and height we can draw on. (i.e. apply the outer margins)
		static public let contentSize = CGSize(
			width: Constants.pageWidth - 2 * Constants.outerMargin,
			height: Constants.pageHeight - 2 * Constants.outerMargin
		)
	}
}
