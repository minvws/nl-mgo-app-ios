/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

// A protocol for the notification center so it is mockable.
public protocol NotificationCenterProtocol {
	
	func addObserver(
		_ observer: Any,
		selector aSelector: Selector,
		name aName: NSNotification.Name?,
		object anObject: Any?
	)
	
	@discardableResult
	func addObserver(
		forName name: NSNotification.Name?,
		object obj: Any?,
		queue: OperationQueue?,
		using block: @escaping @Sendable (Notification) -> Void
	) -> NSObjectProtocol
	
	func post(name aName: NSNotification.Name, object anObject: Any?)
	
	func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?)
	
	func removeObserver(_ observer: Any)
	
	/// Post a accessibility notification
	/// - Parameters:
	///   - notification: the UIAccessibility notification
	///   - argument: optional argument
	///    (Pass nil for the argument if the notification does not specify otherwise See UIAccessibilityConstants.h for a list of notifications.)
	func post(notification: UIAccessibility.Notification, argument: Any?)
	
}

extension NotificationCenter: NotificationCenterProtocol {
	
	// Make NotificationCenter conform to NotificationCenterProtocol to allow mocking
	
	/// Post a accessibility notification
	/// - Parameters:
	///   - notification: the UIAccessibility notification
	///   - argument: optional argument
	///    (Pass nil for the argument if the notification does not specify otherwise See UIAccessibilityConstants.h for a list of notifications.)
	public func post(notification: UIAccessibility.Notification, argument: Any?) {
		UIAccessibility.post(notification: notification, argument: argument)
	}
}
