/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// A Coordinator handles actions to determine the next state or action
protocol Coordinator: AnyObject {
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any  Coordination Action
	func handle(_ action: Coordination.Action)
}

/// Name space for the Coordinator
public struct Coordination {
	
	/// An action that the coordinator should handle
	public struct Action: Equatable {
		
		/// the action identifier
		public var identifier: String
		
		/// optional params for this action
		public var params: [String: AnyHashable]

		/// Initializer
		/// - Parameter identifier: identifier
		public init(identifier: String, params: [String: AnyHashable] = [:]) {
			self.identifier = identifier
			self.params = params
		}
	}
}
