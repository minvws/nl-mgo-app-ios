/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO
import MGOFoundation

final class InputFieldTests: XCTestCase {
	
	@MainActor func test_regularInput() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let input: Binding<String> = Binding(wrappedValue: "Test")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_regularInput_typing() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let input: Binding<String> = Binding(wrappedValue: "")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let textField = try sut.inspect().find(ViewType.TextField.self)
		try textField.setInput("Testing is awesome")
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_error() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let input: Binding<String> = Binding(wrappedValue: "Test")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "Error")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_regularInput_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let input: Binding<String> = Binding(wrappedValue: "Test")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_regularInput_typing_iOS18() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let input: Binding<String> = Binding(wrappedValue: "")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let textField = try sut.inspect().find(ViewType.TextField.self)
		try textField.setInput("Testing is awesome")
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_error_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let input: Binding<String> = Binding(wrappedValue: "Test")
		let error: Binding<LocalizedStringKey> = Binding(wrappedValue: "Error")
		let sut = InputField(input: input, errorMessage: error, title: "Input Test")
		
		// When
		let content = sut
			.frame(width: 340, height: 50)
		
		// Then
		takeSnapShots(content: content)
	}
}
