/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

public class NotificationCenterSpy: NotificationCenterProtocol {

	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	public var invokedAddObserverSelector = false
	public var invokedAddObserverSelectorCount = 0
	public var invokedAddObserverSelectorParameters: (observer: Any, aSelector: Selector, aName: NSNotification.Name?, anObject: Any?)?
	public var invokedAddObserverSelectorParametersList = [(observer: Any, aSelector: Selector, aName: NSNotification.Name?, anObject: Any?)]()

	public func addObserver(
		_ observer: Any,
		selector aSelector: Selector,
		name aName: NSNotification.Name?,
		object anObject: Any?
	) {
		invokedAddObserverSelector = true
		invokedAddObserverSelectorCount += 1
		invokedAddObserverSelectorParameters = (observer, aSelector, aName, anObject)
		invokedAddObserverSelectorParametersList.append((observer, aSelector, aName, anObject))
	}

	public var invokedAddObserverForName = false
	public var invokedAddObserverForNameCount = 0
	public var invokedAddObserverForNameParameters: (name: NSNotification.Name?, obj: Any?, queue: OperationQueue?)?
	public var invokedAddObserverForNameParametersList = [(name: NSNotification.Name?, obj: Any?, queue: OperationQueue?)]()
	public var stubbedAddObserverForNameBlockResult: (Notification, Void)?
	public var stubbedAddObserverForNameResult: NSObjectProtocol!

	public func addObserver(
		forName name: NSNotification.Name?,
		object obj: Any?,
		queue: OperationQueue?,
		using block: @escaping @Sendable (Notification) -> Void
	) -> NSObjectProtocol {
		invokedAddObserverForName = true
		invokedAddObserverForNameCount += 1
		invokedAddObserverForNameParameters = (name, obj, queue)
		invokedAddObserverForNameParametersList.append((name, obj, queue))
		if let result = stubbedAddObserverForNameBlockResult {
			block(result.0)
		}
		return stubbedAddObserverForNameResult
	}

	public var invokedPostName = false
	public var invokedPostNameCount = 0
	public var invokedPostNameParameters: (aName: NSNotification.Name, anObject: Any?)?
	public var invokedPostNameParametersList = [(aName: NSNotification.Name, anObject: Any?)]()

	public func post(name aName: NSNotification.Name, object anObject: Any?) {
		invokedPostName = true
		invokedPostNameCount += 1
		invokedPostNameParameters = (aName, anObject)
		invokedPostNameParametersList.append((aName, anObject))
	}

	public var invokedPostNameObject = false
	public var invokedPostNameObjectCount = 0
	public var invokedPostNameObjectParameters: (aName: NSNotification.Name, anObject: Any?, aUserInfo: [AnyHashable: Any]?)?
	public var invokedPostNameObjectParametersList = [(aName: NSNotification.Name, anObject: Any?, aUserInfo: [AnyHashable: Any]?)]()

	public func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
		invokedPostNameObject = true
		invokedPostNameObjectCount += 1
		invokedPostNameObjectParameters = (aName, anObject, aUserInfo)
		invokedPostNameObjectParametersList.append((aName, anObject, aUserInfo))
	}

	public var invokedRemoveObserver = false
	public var invokedRemoveObserverCount = 0
	public var invokedRemoveObserverParameters: (observer: Any, Void)?
	public var invokedRemoveObserverParametersList = [(observer: Any, Void)]()

	public func removeObserver(_ observer: Any) {
		invokedRemoveObserver = true
		invokedRemoveObserverCount += 1
		invokedRemoveObserverParameters = (observer, ())
		invokedRemoveObserverParametersList.append((observer, ()))
	}

	public var invokedPostNotification = false
	public var invokedPostNotificationCount = 0
	public var invokedPostNotificationParameters: (notification: UIAccessibility.Notification, argument: Any?)?
	public var invokedPostNotificationParametersList = [(notification: UIAccessibility.Notification, argument: Any?)]()

	public func post(notification: UIAccessibility.Notification, argument: Any?) {
		invokedPostNotification = true
		invokedPostNotificationCount += 1
		invokedPostNotificationParameters = (notification, argument)
		invokedPostNotificationParametersList.append((notification, argument))
	}
}
