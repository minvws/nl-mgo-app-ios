// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FileStorage",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "FileStorage",
			targets: ["FileStorage"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "MGODebug", path: "../MGODebug"),
		.package(name: "Observatory", path: "../Observatory")
	],
	targets: [
		.target(
			name: "FileStorage",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "Observatory", package: "Observatory"),
			],
			),
		.testTarget(
			name: "FileStorageTests",
			dependencies: [
				"FileStorage"
			],
			resources: [.process("Resources")]
		)
	]
)
