/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct Feedback: Equatable {
	
	// Equatable
	public static func == (lhs: Feedback, rhs: Feedback) -> Bool {
		
		return lhs.heading == rhs.heading &&
		lhs.type == rhs.type &&
		lhs.subheading == rhs.subheading
	}
	
	/// The heading for the feedback
	public var heading: String
	
	/// The sub heading for the feedback
	public var subheading: String
	
	/// The title for the action
	public var actionTitle: String?
	
	/// The action that could be taken
	public var action: (() -> Void)?
	
	/// The type of the feedback (.info / .warning  / . error  / .success)
	public var type: FeedbackType
	
	/// Create a Feedback object
	/// - Parameters:
	///   - title: the title for the feedback
	///   - subtitle: the subtitle  for the feedback
	///   - actionTitle: the title for the action
	///   - type: the type for the feedback (.info / .warning  / . error  / .success)
	///   - perform: the action to perform when the user presses on the action button
	public init(
		title: String,
		subtitle: String,
		actionTitle: String? = nil,
		type: FeedbackType,
		perform: (() -> Void)? = nil) {
			self.heading = title
			self.subheading = subtitle
			self.actionTitle = actionTitle
			self.type = type
			self.action = perform
		}
}
