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
		// Internal
		//		.package(url: "https://github.com/smart-on-fhir/Swift-SMART", exact: "3.2.0"),
		.package(name: "Swift-SMART", path: "../Swift-SMART"),
		
		// Testing
		.package(url: "https://github.com/Quick/Nimble", exact: "13.2.1")
	],
	targets: [
		.target(
			name: "FHIRClient",
			dependencies: [
				.product(name: "SMART", package: "Swift-SMART")
			]
		),
		.testTarget(
			name: "FHIRClientTests",
			dependencies: [
				"FHIRClient",
				.product(name: "Nimble", package: "Nimble")
			],
			resources: [.process("Resources")]
		)
	]
)
