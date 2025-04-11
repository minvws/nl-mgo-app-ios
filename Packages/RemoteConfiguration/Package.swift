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
		.package(name: "MGODebug", path: "../MGODebug"),
		.package(name: "Observatory", path: "../Observatory"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.7.2"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.8.2"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.1.0"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "RemoteConfiguration",
			dependencies: [
				.product(name: "FileStorage", package: "FileStorage"),
				.product(name: "MGODebug", package: "MGODebug"),
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
