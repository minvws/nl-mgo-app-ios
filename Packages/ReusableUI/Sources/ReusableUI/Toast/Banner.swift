/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct Banner: Codable, Equatable {
	
	public enum BannerType: String, Codable {
		case info
		case warning
		case error
		case success
	}
	
	/// The title of the banner
	public var title: String
	
	/// The subtitle of the banner
	public var subtitle: String
	
	/// The type of the banner (.info / .warning  / . error  / .success)
	public var type: BannerType
	
	/// Create a Banner object
	/// - Parameters:
	///   - title: the title of the banner
	///   - text: the text of the banner
	///   - type: the type of the banner (.info / .warning  / . error  / .success)
	///   - perform: The action to perform when the user presses on the close button
	public init(
		title: String,
		subtitle: String,
		type: Banner.BannerType) {
		self.title = title
		self.subtitle = subtitle
		self.type = type
	}
}
