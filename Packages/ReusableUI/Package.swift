// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ReusableUI",
	platforms: [.iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "ReusableUI",
			targets: ["ReusableUI"]),
	],
	dependencies: [
		// Internal
		.package(name: "Theme", path: "../Theme"),
		.package(name: "RijksoverheidFont", path: "../RijksoverheidFont"),
		
		// External
		.package(url: "https://github.com/siteline/SwiftUI-Introspect", exact: "1.3.0"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "ReusableUI",
			dependencies: [
				.product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
				.product(name: "Theme", package: "Theme"),
				.product(name: "RijksoverheidFont", package: "RijksoverheidFont")
			],
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "ReusableUITests",
			dependencies: [
				"ReusableUI",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
