// swift-tools-version: 5.10
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
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "FileStorage",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug"),
			]
		),
		.testTarget(
			name: "FileStorageTests",
			dependencies: [
				"FileStorage",
				.product(name: "MGOTest", package: "MGOTest")
			],
			resources: [.process("Resources")]
		)
	]
)
