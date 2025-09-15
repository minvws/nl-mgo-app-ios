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
	
	func post(
		name aName: NSNotification.Name,
		object anObject: Any?
	)
	
	func post(
		name aName: NSNotification.Name,
		object anObject: Any?,
		userInfo aUserInfo: [AnyHashable: Any]?
	)
	
	func removeObserver(_ observer: Any)
	
	/// Post a accessibility notification
	/// - Parameters:
	///   - notification: the UIAccessibility notification
	///   - argument: optional argument
	///    (Pass nil for the argument if the notification does not specify otherwise See UIAccessibilityConstants.h for a list of notifications.)
	@MainActor func post(
		notification: UIAccessibility.Notification,
		argument: Any?
	)
	
	/// Returns a publisher that emits events when broadcasting notifications.
	/// - Parameters:
	///   - name: The name of the notification to publish
	///   - object: The object posting the named notification. If nil, the publisher emits elements for
	///    any object producing a notification with the given name
	/// - Returns: publisher that emits events when broadcasting notifications
	func publisher(
		for name: Notification.Name,
		object: AnyObject?
	) -> NotificationCenter.Publisher
}

extension NotificationCenter: NotificationCenterProtocol {

	/// Post a accessibility notification
	/// - Parameters:
	///   - notification: the UIAccessibility notification
	///   - argument: optional argument
	///    (Pass nil for the argument if the notification does not specify otherwise See UIAccessibilityConstants.h for a list of notifications.)
	@MainActor public func post(
		notification: UIAccessibility.Notification,
		argument: Any?
	) {
		UIAccessibility.post(
			notification: notification,
			argument: argument
		)
	}
}
