/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class LaunchArgumentsHandler {
	
	/// Should we disable transitions to skip animations?
	public static func shouldDisableTransitions() -> Bool {
		
		return CommandLine.arguments.contains("-disableTransitions")
	}
	
	/// Should we restart upon start?
	public static func shouldResetOnStart() -> Bool {
		
		return CommandLine.arguments.contains("-resetOnStart")
	}
	
	/// Should we show the update required scene?
	public static func shouldShowUpdateRequired() -> Bool {
		
		return CommandLine.arguments.contains("-updateRequired")
	}
	
	/// Do we have a pincode?
	public static func hasPincodeSet() -> Bool {
		
		return CommandLine.arguments.contains("-hasPincodeSet")
	}
}
