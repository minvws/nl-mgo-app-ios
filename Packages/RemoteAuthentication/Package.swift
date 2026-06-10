// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RemoteAuthentication",
	platforms: [.iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "RemoteAuthentication",
			targets: ["RemoteAuthentication"]),
	],
	dependencies: [
		
		// Internal
		.package(name: "OpenAPICore", path: "../OpenAPICore"),
		.package(name: "OpenAPIMiddleware", path: "../OpenAPIMiddleware"),
		.package(name: "MGODebug", path: "../MGODebug"),

		// External
		.package(
			url: "https://github.com/apple/swift-openapi-generator",
			exact: "1.12.2"
		),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "RemoteAuthentication",
			dependencies: [
				.product(name: "OpenAPICore", package: "OpenAPICore"),
				.product(name: "OpenAPIMiddleware", package: "OpenAPIMiddleware"),
				.product(name: "MGODebug", package: "MGODebug")
			],
			plugins: [
				.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
			]
		),
		.testTarget(
			name: "RemoteAuthenticationTests",
			dependencies: [
				"RemoteAuthentication",
				.product(name: "MGOTest", package: "MGOTest")
			]
		),
	]
)
