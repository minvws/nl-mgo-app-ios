/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Do we have remote authentication?
	public static func hasRemoteAuthentication() -> Bool {
		
		return CommandLine.arguments.contains("-withRemoteAuthentication")
	}
	
	/// Should we enable faceID?
	public static func shouldEnableFaceID() -> Bool {
		
		return CommandLine.arguments.contains("-enableFaceID")
	}
	
	/// Should we use a provided pincode
	/// - Returns: pincode
	public static func hasPincode() -> String? {
		
		if let commandlineArgument = CommandLine.arguments.first(where: { $0.lowercased().starts(with: "-pincode:") }),
		   let pincode = commandlineArgument.split(separator: ":").last {
			return String(pincode)
		}
		return nil
	}
}
