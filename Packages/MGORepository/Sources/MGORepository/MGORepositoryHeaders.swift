/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The Request headers for MGO
public struct MGORepositoryHeaders {
	
	/// The dva target
	public var dvaTarget: String
	
	/// The id of the dataservice
	public var dataServiceId: String
	
	/// The medmij id of a healthcare provider
	public var medmijId: String?
	
	/// The Basic AUTH username
	public var username: String?
	
	/// The Basic AUTH password
	public var password: String?
	
	/// Create the MGO Repository Headers
	/// - Parameters:
	///   - dvaTarget: the dva target
	///   - dataServiceId: the id of the dataservice, i.e."48" for BgZ
	///   - medmijId: the medmij id of a healthcare provider, i.e. "een.huisarts@medmij"
	///   - username: the Basic AUTH username
	///   - password: the Basic AUTH password
	public init(
		dvaTarget: String,
		dataServiceId: String,
		medmijId: String? = nil,
		username: String? = nil,
		password: String? = nil
	) {
		self.dvaTarget = dvaTarget
		self.dataServiceId = dataServiceId
		self.medmijId = medmijId
		self.username = username
		self.password = password
	}
}
