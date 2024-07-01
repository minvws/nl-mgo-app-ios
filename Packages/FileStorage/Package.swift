// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FileStorage",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "FileStorage",
			targets: ["FileStorage"]
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
			name: "FileStorage",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
			]
		),
		.testTarget(
			name: "FileStorageTests",
			dependencies: [
				"FileStorage",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
