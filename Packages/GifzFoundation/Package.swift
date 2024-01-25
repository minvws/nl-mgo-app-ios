// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GifzFoundation",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "GifzFoundation",
			targets: ["GifzFoundation"]
		)
	],
	dependencies: [
		
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// External
		.package(url: "https://github.com/lm/navigation-stack-backport", from: "1.1.0"),
		.package(url: "https://github.com/pointfreeco/swift-perception", exact: "1.1.1")
	],
	targets: [
		.target(
			name: "GifzFoundation",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
				.product(name: "NavigationStackBackport", package: "navigation-stack-backport"),
				.product(name: "Perception", package: "swift-perception")
			]
		)
	]
)
