// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SharedCore",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "SharedCore",
			targets: ["SharedCore"]),
	],
	dependencies: [
		// Internal
		.package(name: "MGODebug", path: "../MGODebug"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "SharedCore",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug")
			],
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "SharedCoreTests",
			dependencies: [
				"SharedCore",
					.product(name: "MGOTest", package: "MGOTest")
			],
			resources: [.process("Resources")]
		)
	]
)
