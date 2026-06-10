// swift-tools-version: 6.2
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
		.package(url: "https://github.com/apple/swift-http-types", exact: "1.6.0"),

		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "FHIRClient",
			dependencies: [
				.product(name: "HTTPTypes", package: "swift-http-types"),
				.product(name: "HTTPTypesFoundation", package: "swift-http-types"),
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
