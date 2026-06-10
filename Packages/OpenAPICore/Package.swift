// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OpenAPICore",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	products: [
		.library(
			name: "OpenAPICore",
			targets: ["OpenAPICore"]
		)
	],
	dependencies: [
		// External
		.package(
			url: "https://github.com/apple/swift-openapi-runtime",
			exact: "1.12.0"
		),
		.package(
			url: "https://github.com/apple/swift-openapi-urlsession",
			exact: "1.3.0"
		)
	],
	targets: [
		.target(
			name: "OpenAPICore",
			dependencies: [
				.product(
					name: "OpenAPIRuntime",
					package: "swift-openapi-runtime"
				),
				.product(
					name: "OpenAPIURLSession",
					package: "swift-openapi-urlsession"
				)
			]
		)
	]
)
