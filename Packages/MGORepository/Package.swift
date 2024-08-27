// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGORepository",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGORepository",
			targets: ["MGORepository"]),
	],
	dependencies: [

		// Internal
		.package(name: "FHIRClient", path: "../FHIRClient"),
		.package(name: "FHIRExtensions", path: "../FHIRExtensions"),
		.package(name: "FHIRParser", path: "../FHIRParser"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "MGORepository",
			dependencies: [
				.product(name: "FHIRClient", package: "FHIRClient"),
				.product(name: "FHIRExtensions", package: "FHIRExtensions"),
				.product(name: "FHIRParser", package: "FHIRParser")
			]
		),
		.testTarget(
			name: "MGORepositoryTests",
			dependencies: [
				"MGORepository",
				.product(name: "MGOTest", package: "MGOTest")
			],
			resources: [.process("Resources")]
		)
	]
)
