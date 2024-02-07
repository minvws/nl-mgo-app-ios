// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOFoundation",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGOFoundation",
			targets: ["MGOFoundation"]
		)
	],
	dependencies: [
		
		// Internal
		.package(name: "Managers", path: "../Managers"),
		
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main")
	],
	targets: [
		.target(
			name: "MGOFoundation",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
				.product(name: "Managers", package: "Managers")
			]
		)
	]
)
