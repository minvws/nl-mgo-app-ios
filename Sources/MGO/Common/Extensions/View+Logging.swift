/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

extension View {
	
	/// Log Verbose
	/// - Parameters:
	///   - message: the message to log
	///   - values: any values to be logged
	/// - Returns: some View
	public func logVerbose(_ message: String, _ values: Any...) -> some View {
		modifier(LogModifier(message, .verbose, values))
	}
	
	/// Log Debug
	/// - Parameters:
	///   - message: the message to log
	///   - values: any values to be logged
	/// - Returns: some View
	public func logDebug(_ message: String, _ values: Any...) -> some View {
		modifier(LogModifier(message, .debug, values))
	}
	
	/// Log Info
	/// - Parameters:
	///   - message: the message to log
	///   - values: any values to be logged
	/// - Returns: some View
	public func logInfo(_ message: String, _ values: Any...) -> some View {
		modifier(LogModifier(message, .info, values))
	}
	
	/// Log Warning
	/// - Parameters:
	///   - message: the message to log
	///   - values: any values to be logged
	/// - Returns: some View
	public func logWarning(_ message: String, _ values: Any...) -> some View {
		modifier(LogModifier(message, .warning, values))
	}
	
	/// Log Error
	/// - Parameters:
	///   - message: the message to log
	///   - values: any values to be logged
	/// - Returns: some View
	public func logError(_ message: String, _ values: Any...) -> some View {
		modifier(LogModifier(message, .error, values))
	}
}

public struct LogModifier: ViewModifier {
	
	enum LogLevel {
		case verbose
		case debug
		case info
		case warning
		case error
	}
	
	/// Log Modifier
	/// - Parameters:
	///   - message: the message to be logged
	///   - logLevel: the log level
	///   - values: any values to log
	init(_ message: String, _ logLevel: LogLevel, _ values: Any... ) {
		switch logLevel {
			case .verbose:
				logVerbose(message, values)
			case .debug:
				logDebug(message, values)
			case .info:
				logInfo(message, values)
			case .warning:
				logWarning(message, values)
			case .error:
				logError(message, values)
		}
	}
	
	public func body(content: Content) -> some View {
		content
	}
}
