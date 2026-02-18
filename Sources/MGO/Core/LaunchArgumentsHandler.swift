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
	
	/// Should we enable automatic localization?
	public static func isAutomaticLocalizationEnabled() -> Bool {
		
		return CommandLine.arguments.contains("-automaticLocalizationEnabled")
	}
	
	/// Should we enable demo mode?
	public static func isDemo() -> Bool {
		
		return CommandLine.arguments.contains("-demoMode")
	}
}
