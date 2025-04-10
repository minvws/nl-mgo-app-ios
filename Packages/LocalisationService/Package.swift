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
		// Internal
		.package(name: "AuthorizationMiddleware", path: "../AuthorizationMiddleware"),
		.package(name: "FileStorage", path: "../FileStorage"),
		.package(name: "Observatory", path: "../Observatory"),
		.package(name: "MGODebug", path: "../MGODebug"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.7.2"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.8.2"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.1.0"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "LocalisationService",
			dependencies: [
				.product(name: "AuthorizationMiddleware", package: "AuthorizationMiddleware"),
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
			name: "LocalisationServiceTests",
			dependencies: [
				"LocalisationService",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
