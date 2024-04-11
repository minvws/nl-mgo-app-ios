// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOUI",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGOUI",
			targets: ["MGOUI"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "ReusableUI", path: "../ReusableUI"),
		.package(name: "RijksoverheidFont", path: "../RijksoverheidFont"),
		.package(name: "Theme", path: "../Theme"),
		
		// External
		.package(url: "https://github.com/lm/navigation-stack-backport", from: "1.1.0")
	],
	targets: [
		.target(
			name: "MGOUI",
			dependencies: [
				.product(name: "NavigationStackBackport", package: "navigation-stack-backport"),
				.product(name: "ReusableUI", package: "ReusableUI"),
				.product(name: "RijksoverheidFont", package: "RijksoverheidFont"),
				.product(name: "Theme", package: "Theme")
			]
		)
	]
)
