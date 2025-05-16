/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
	
	// the key for this value
	public let key: String
	
	// The default value
	public let defaultValue: Value
	
	// the container, defaults to standard
	public var container: UserDefaults = .standard
	
	/// Access to the wrapped value
	public var wrappedValue: Value {
		get {
			return container.object(forKey: key) as? Value ?? defaultValue
		}
		set {
			container.set(newValue, forKey: key)
		}
	}
}
