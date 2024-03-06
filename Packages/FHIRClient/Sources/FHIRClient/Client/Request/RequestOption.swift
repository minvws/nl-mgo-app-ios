/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
Options to pass along to request handlers.
*/
public struct RequestOption: OptionSet {
	
	public let rawValue: Int
	
	/** Designated initializer. Without this, Swift 3.0 compiler wants to insert a million `public struct` and will still complain... */
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Add a `_summary=true` parameter to only receive a summary of the resource.
	public static let summary = RequestOption(rawValue: 1)
	
	/// Tolerate JSON validation errors when receiving a response, i.e. don't throw upon instantiation, use what's provided.
	public static let lenient = RequestOption(rawValue: 2)
}
