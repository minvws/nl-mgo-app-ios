// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LocalisationServiceClient",
	platforms: [.iOS(.v13)],
	products: [
		.library(
			name: "LocalisationServiceClient",
			targets: ["LocalisationServiceClient"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.2.1"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.4.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.0.1")
	],
	targets: [
		.target(
			name: "LocalisationServiceClient",
			dependencies: [
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			],
			plugins: [
				.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
			]
		)
	]
)
