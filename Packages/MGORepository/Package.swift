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

		// External
		.package(name: "FHIRClient", path: "../FHIRClient"),
		.package(name: "FHIRExtensions", path: "../FHIRExtensions"),
		
		// Testing
		.package(url: "https://github.com/Quick/Nimble", exact: "13.3.0")
	],
	targets: [
		.target(
			name: "MGORepository",
			dependencies: [
				.product(name: "FHIRClient", package: "FHIRClient"),
				.product(name: "FHIRExtensions", package: "FHIRExtensions")
			]
		),
		.testTarget(
			name: "MGORepositoryTests",
			dependencies: [
				"MGORepository",
				.product(name: "Nimble", package: "Nimble")
			]
//			resources: [.process("Resources")]
		)
	]
)
