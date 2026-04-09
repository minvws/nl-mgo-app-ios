/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI

public struct HealthDataViewConfig: Equatable, Hashable, Codable, Sendable {
	
	/// Create a config object for the Health Data View
	/// - Parameters:
	///   - backButtonTitle: the title for the back button
	///   - inSheet: should the view be in a sheet?
	public init(
		backButtonTitle: String? = nil,
		inSheet: Bool
	) {
		self.backButtonTitle = backButtonTitle
		self.inSheet = inSheet
	}
	
	/// the title for the back button
	public let backButtonTitle: String?
	
	/// should the view be in a sheet?
	public let inSheet: Bool
}
