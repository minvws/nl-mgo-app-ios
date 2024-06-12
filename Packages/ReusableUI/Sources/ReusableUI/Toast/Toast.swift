/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct Toast: Codable, Equatable {
	
	public enum ToastType: String, Codable {
		case info
		case warning
		case error
		case success
	}
	
	/// The title of the Toast
	public var title: String
	
	/// The subtitle of the Toast
	public var subtitle: String
	
	/// The type of the Toast (.info / .warning  / . error  / .success)
	public var type: ToastType
	
	/// Create a Toast object
	/// - Parameters:
	///   - title: the title of the Toast
	///   - text: the text of the Toast
	///   - type: the type tof the Toast (.info / .warning  / . error  / .success)
	///   - perform: The action to perform when the user presses on the close button
	public init(
		title: String,
		subtitle: String,
		type: Toast.ToastType) {
		self.title = title
		self.subtitle = subtitle
		self.type = type
	}
}
