/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class NotificationCenterSpy: NotificationCenterProtocol {
	
	public init() {}

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

	public var invokedPost = false
	public var invokedPostCount = 0
	public var invokedPostParameters: (aName: NSNotification.Name, anObject: Any?)?
	public var invokedPostParametersList = [(aName: NSNotification.Name, anObject: Any?)]()

	public func post(name aName: NSNotification.Name, object anObject: Any?) {
		invokedPost = true
		invokedPostCount += 1
		invokedPostParameters = (aName, anObject)
		invokedPostParametersList.append((aName, anObject))
	}

	public var invokedPostName = false
	public var invokedPostNameCount = 0
	public var invokedPostNameParameters: (aName: NSNotification.Name, anObject: Any?, aUserInfo: [AnyHashable: Any]?)?
	public var invokedPostNameParametersList = [(aName: NSNotification.Name, anObject: Any?, aUserInfo: [AnyHashable: Any]?)]()

	public func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
		invokedPostName = true
		invokedPostNameCount += 1
		invokedPostNameParameters = (aName, anObject, aUserInfo)
		invokedPostNameParametersList.append((aName, anObject, aUserInfo))
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
}
