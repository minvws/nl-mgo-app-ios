// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FHIRClient",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "FHIRClient",
			targets: ["FHIRClient"]),
	],
	dependencies: [

		// External
		.package(url: "https://github.com/apple/FHIRModels", exact: "0.5.0"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "FHIRClient",
			dependencies: [
				.product(name: "ModelsSTU3", package: "FHIRModels")
			]
		),
		.testTarget(
			name: "FHIRClientTests",
			dependencies: [
				"FHIRClient",
				.product(name: "MGOTest", package: "MGOTest")
			],
			resources: [.process("Resources")]
		)
	]
)
