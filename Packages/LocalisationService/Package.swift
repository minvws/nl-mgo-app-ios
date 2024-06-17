// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LocalisationService",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "LocalisationService",
			targets: ["LocalisationService"]
		)
	],
	dependencies: [
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.2.1"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.4.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.0.1"),

		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "LocalisationService",
			dependencies: [
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			],
			plugins: [
				.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
			]
		),
		.testTarget(
			name: "LocalisationServiceTests",
			dependencies: [
				"LocalisationService",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)

