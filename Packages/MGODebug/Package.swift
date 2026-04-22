// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGODebug",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	products: [
		.library(
			name: "MGODebug",
			targets: ["MGODebug"])
	],
	dependencies: [
		.package(
			url: "https://github.com/RoolProductions/SwiftLogging",
			exact: "1.0.0"
		)
	],
	targets: [
		.target(
			name: "MGODebug",
			dependencies: [
				.product(name: "SwiftLogging", package: "SwiftLogging")
			],
		)
	]
)
