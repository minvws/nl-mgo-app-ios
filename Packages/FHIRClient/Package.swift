// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FHIRClient",
	products: [
		.library(
			name: "FHIRClient",
			targets: ["FHIRClient"]),
	],
	dependencies: [
//		.package(url: "https://github.com/smart-on-fhir/Swift-SMART", exact: "3.2.0"),
		// Internal
		.package(name: "Swift-SMART", path: "../Swift-SMART"),
	],
	targets: [
		.target(
			name: "FHIRClient",
			dependencies: [
				.product(name: "SMART", package: "Swift-SMART"),
			]
		),
		.testTarget(
			name: "FHIRClientTests",
			dependencies: ["FHIRClient"]),
	]
)
