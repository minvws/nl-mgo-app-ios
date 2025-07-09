// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Theme",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "Theme",
			targets: ["Theme"]
		)
	],
	dependencies: [
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "Theme",
			resources: [.process("Resources")],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "ThemeTests",
			dependencies: [
				"Theme",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
