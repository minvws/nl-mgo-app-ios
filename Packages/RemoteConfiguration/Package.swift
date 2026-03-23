// swift-tools-version: 6.2
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
		.package(name: "OpenAPIMiddleware", path: "../OpenAPIMiddleware"),
		.package(name: "FileStorage", path: "../FileStorage"),
		.package(name: "MGODebug", path: "../MGODebug"),
		.package(name: "Observatory", path: "../Observatory"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.10.4"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.11.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.2.0"),
		
		// Testing
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0")
	],
	targets: [
		.target(
			name: "RemoteConfiguration",
			dependencies: [
				.product(name: "OpenAPIMiddleware", package: "OpenAPIMiddleware"),
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
				.product(name: "FileStorage", package: "FileStorage"),
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
			]
		)
	]
)
