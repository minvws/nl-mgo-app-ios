/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

@testable import Observatory
import MGOTest

class ObservatoryTests: XCTestCase {
	typealias Value = String
	
	var sut: Observatory<Value>!
	var updateCallback: ((Value) -> Void)!
	var callbackRecorder: ObserverCallbackRecorder<Value>!
	
	override func setUp() {
		super.setUp()
		callbackRecorder = .init()
	}
	
	func test_registeringObserver_doesntSendValues() {
		
		// Arrange
		(sut, updateCallback) = Observatory.create()
		
		// Act
		_ = sut.append(observer: callbackRecorder.recordEvents)
 
		// Assert
		expect(self.callbackRecorder.values).to(beEmpty())
	}
	
	func test_registeringObserver_afterSendingValue_doesntSendValues() {
		
		// Arrange
		(sut, updateCallback) = Observatory.create()
		
		// Act
		updateCallback("🍕")
		_ = sut.append(observer: callbackRecorder.recordEvents)
 
		// Assert
		expect(self.callbackRecorder.values).to(beEmpty())
	}
	
	func test_sendingValue_updatesObserver() {
		// Arrange
		(sut, updateCallback) = Observatory.create()
		_ = sut.append(observer: callbackRecorder.recordEvents)
		
		// Act
		let valueSent = "🍕"
		updateCallback(valueSent)
		
		// Assert
		expect(self.callbackRecorder.values.count) == 1
		expect(self.callbackRecorder.values[0]) == valueSent
	}
	
	func test_sendingValue_updatesMultipleObservers() {
		// Arrange
		
		let callbackRecorder1 = ObserverCallbackRecorder<Value>()
		let callbackRecorder2 = ObserverCallbackRecorder<Value>()
		
		(sut, updateCallback) = Observatory.create()
		_ = sut.append(observer: callbackRecorder1.recordEvents)
		_ = sut.append(observer: callbackRecorder2.recordEvents)
		
		// Act
		let valueSent = "🍕"
		updateCallback(valueSent)
		
		// Assert
		expect(callbackRecorder1.values.count) == 1
		expect(callbackRecorder1.values[0]) == valueSent
		expect(callbackRecorder2.values) == callbackRecorder1.values
	}
	
	func test_sendingValueAfterUnregisteringObserver_doesNotUpdateObserver() {
		// Arrange
		(sut, updateCallback) = Observatory.create()
		let token = sut.append(observer: callbackRecorder.recordEvents)
		
		// Act
		sut.remove(observerToken: token)
		
		let valueSent = "🍕"
		updateCallback(valueSent)
		
		// Assert
		expect(self.callbackRecorder.values).to(beEmpty())
	}
}
