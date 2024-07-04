// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Observatory",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "Observatory",
			targets: ["Observatory"]
		)
	],
	dependencies: [
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "Observatory",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
			]
		),
		.testTarget(
			name: "ObservatoryTests",
			dependencies: [
				"Observatory",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
