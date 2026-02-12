// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OrganizationSearch",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "OrganizationSearch",
			targets: ["OrganizationSearch"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "MGODebug", path: "../MGODebug")
	],
	targets: [
		.target(
			name: "OrganizationSearch",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug")
			],
			resources: [.process("Resources")],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "OrganizationSearchTests",
			dependencies: ["OrganizationSearch"]
		)
	]
)
