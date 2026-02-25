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
		.package(name: "MGODebug", path: "../MGODebug"),
		// External
		.package(url: "https://github.com/groue/GRDB.swift", exact: "7.10.0")
	],
	targets: [
		.target(
			name: "OrganizationSearch",
			dependencies: [
				.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "GRDB", package: "GRDB.swift")
			],
			resources: [.process("Resources")],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "OrganizationSearchTests",
			dependencies: ["OrganizationSearch"],
			resources: [.process("Resources")]
		)
	]
)
