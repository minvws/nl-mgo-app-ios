// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGODebug",
	products: [
		.library(
			name: "MGODebug",
			targets: ["MGODebug"])
	],
	dependencies: [
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main")
	],
	targets: [
		.target(
			name: "MGODebug",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules")
			]
		)
	]
)
