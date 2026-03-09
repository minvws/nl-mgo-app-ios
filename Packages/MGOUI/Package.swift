// swift-tools-version: 6.2
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
		.package(name: "OSVersion", path: "../OSVersion"),
		.package(name: "ReusableUI", path: "../ReusableUI"),
		
		// External
		.package(url: "https://github.com/devicekit/DeviceKit", exact: "5.8.0"),
		.package(url: "https://github.com/lm/navigation-stack-backport", exact: "1.1.0")
	],
	targets: [
		.target(
			name: "MGOUI",
			dependencies: [
				.product(name: "DeviceKit", package: "DeviceKit"),
				.product(name: "NavigationStackBackport", package: "navigation-stack-backport"),
				.product(name: "OSVersion", package: "OSVersion"),
				.product(name: "ReusableUI", package: "ReusableUI")
			],
			)
	]
)
