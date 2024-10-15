//
//  Key.swift
//
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import SwiftUI

struct IsScrollingValueKey: EnvironmentKey {
	static var defaultValue: Bool = false
}

public extension EnvironmentValues {
	
	var isScrolling: Bool {
		get { self[IsScrollingValueKey.self] }
		set { self[IsScrollingValueKey.self] = newValue }
	}
}

public struct MinValueKey: PreferenceKey {
	
	public static var defaultValue: CGRect = .zero
	
	public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

struct IsScrollingPreferenceKey: PreferenceKey {
	static var defaultValue: [Bool] = []
	
	static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
		value.append(contentsOf: nextValue())
	}
}
