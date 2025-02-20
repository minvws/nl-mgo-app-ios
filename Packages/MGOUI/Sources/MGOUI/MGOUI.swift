/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

// System
@_exported import SwiftUI

// Internal
@_exported import ReusableUI
@_exported import RijksoverheidFont
@_exported import Theme

// External
@_exported import DeviceKit
@_exported import NavigationStackBackport
@_exported import SwiftUIIntrospect

public var isiPhoneSE: Bool {
	Device.current == .iPhoneSE || Device.current == .simulator(.iPhoneSE)
}
