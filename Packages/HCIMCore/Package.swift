// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HCIMCore",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "HCIMCore",
			targets: ["HCIMCore"]),
	],
	dependencies: [
		// Internal
		.package(name: "MGODebug", path: "../MGODebug"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "HCIMCore",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug")
			],
			resources: [.process("Resources")],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "HCIMCoreTests",
			dependencies: ["HCIMCore"],
			resources: [.process("Resources")]
		)
	]
)
