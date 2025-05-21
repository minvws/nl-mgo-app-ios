/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// See Save an extra boolean @State variable when using alerts or sheets: https://www.fadel.io/blog/posts/30-tips-to-make-you-a-better-ios-developer
extension Binding {
	
	/// Is the binding value presence? i.e. is it nil?
	/// - Returns: True if the binding value is not nil
	public func presence<T>() -> Binding<Bool> where Value == Optional<T> { // swiftlint:disable:this syntactic_sugar
		return .init {
			self.wrappedValue != nil
		} set: { newValue in
			precondition(newValue == false)
			self.wrappedValue = nil
		}
	}
}
