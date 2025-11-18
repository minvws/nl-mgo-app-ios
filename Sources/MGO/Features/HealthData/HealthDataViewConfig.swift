/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI

public struct HealthDataViewConfig: Equatable, Hashable, Codable, Sendable {
	
	/// Create a config object for the Health Data View
	/// - Parameters:
	///   - backButtonTitle: the title for the back button
	///   - titleInline: should the title be inline?
	///   - inSheet: should the view be in a sheet?
	public init(
		backButtonTitle: String? = nil,
		titleInline: Bool,
		inSheet: Bool
	) {
		self.backButtonTitle = backButtonTitle
		self.titleInline = titleInline
		self.inSheet = inSheet
	}
	
	/// the title for the back button
	public let backButtonTitle: String?
	
	/// should the title be inline?
	public let titleInline: Bool
	
	/// should the view be in a sheet?
	public let inSheet: Bool
}
