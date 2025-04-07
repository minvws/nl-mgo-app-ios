// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "AuthorizationMiddleware",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "AuthorizationMiddleware",
			targets: ["AuthorizationMiddleware"]),
	],
	dependencies: [
		
		// External
		.package(url: "https://github.com/apple/swift-http-types", exact: "1.4.0"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.8.2"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "AuthorizationMiddleware",
			dependencies: [
				.product(name: "HTTPTypes", package: "swift-http-types"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
			]
		),
		.testTarget(
			name: "AuthorizationMiddlewareTests",
			dependencies: [
				"AuthorizationMiddleware",
				.product(name: "MGOTest", package: "MGOTest")
			]
		),
	]
)
