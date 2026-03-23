// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OpenAPIMiddleware",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "OpenAPIMiddleware",
			targets: ["OpenAPIMiddleware"]),
	],
	dependencies: [

		// External
		.package(url: "https://github.com/apple/swift-http-types", exact: "1.5.1"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.11.0"),

		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "OpenAPIMiddleware",
			dependencies: [
				.product(name: "HTTPTypes", package: "swift-http-types"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
			],
			),
		.testTarget(
			name: "OpenAPIMiddlewareTests",
			dependencies: [
				"OpenAPIMiddleware",
				.product(name: "MGOTest", package: "MGOTest")
			]
		),
	]
)
