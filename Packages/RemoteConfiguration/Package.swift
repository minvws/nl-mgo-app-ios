// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RemoteConfiguration",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "RemoteConfiguration",
			targets: ["RemoteConfiguration"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "FileStorage", path: "../FileStorage"),
		.package(name: "Observatory", path: "../Observatory"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.4.0"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.6.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.0.2"),

		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "RemoteConfiguration",
			dependencies: [
				.product(name: "FileStorage", package: "FileStorage"),
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
				.product(name: "Observatory", package: "Observatory"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			],
			plugins: [
				.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
			]
		),
		.testTarget(
			name: "RemoteConfigurationTests",
			dependencies: [
				"RemoteConfiguration",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
