// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FHIRExtensions",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "FHIRExtensions",
			targets: ["FHIRExtensions"]),
	],
	dependencies: [

		// External
		.package(url: "https://github.com/apple/FHIRModels", exact: "0.5.0"),
		
		// Testing
		.package(url: "https://github.com/Quick/Nimble", exact: "13.3.0")
	],
	targets: [
		.target(
			name: "FHIRExtensions",
			dependencies: [
				.product(name: "ModelsSTU3", package: "FHIRModels")
			]
		),
		.testTarget(
			name: "FHIRExtensionsTests",
			dependencies: [
				"FHIRExtensions",
				.product(name: "Nimble", package: "Nimble")
			],
			resources: [.process("Resources")]
		)
	]
)
