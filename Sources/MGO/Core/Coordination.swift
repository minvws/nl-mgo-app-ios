/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		
		/// Initializer
		/// - Parameter identifier: identifier
		public init(identifier: String, params: [String] = []) {
			self.identifier = identifier
			self.params = params
		}
		
		public var identifier: String
		
		public var params: [String]
	}
}
