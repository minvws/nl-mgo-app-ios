// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ParsingCore",
	platforms: [.iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "ParsingCore",
			targets: ["ParsingCore"]),
	],
	dependencies: [

		// Internal
		.package(name: "FHIRClient", path: "../FHIRClient"),
		.package(name: "FHIRExtensions", path: "../FHIRExtensions"),
		
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "ParsingCore",
			dependencies: [
				.product(name: "FHIRClient", package: "FHIRClient"),
				.product(name: "FHIRExtensions", package: "FHIRExtensions"),
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
			],
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "ParsingCoreTests",
			dependencies: [
				"ParsingCore",
					.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
