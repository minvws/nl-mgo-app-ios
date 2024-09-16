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
		.package(name: "FHIRParser", path: "../FHIRParser"),
		.package(name: "Observatory", path: "../Observatory"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "MGORepository",
			dependencies: [
				.product(name: "FHIRClient", package: "FHIRClient"),
				.product(name: "FHIRParser", package: "FHIRParser"),
				.product(name: "Observatory", package: "Observatory")
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
