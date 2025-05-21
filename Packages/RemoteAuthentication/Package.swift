// swift-tools-version: 6.0
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
		.package(name: "AuthorizationMiddleware", path: "../AuthorizationMiddleware"),
		.package(name: "MGODebug", path: "../MGODebug"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.7.2"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.8.2"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.1.0"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "RemoteAuthentication",
			dependencies: [
				.product(name: "AuthorizationMiddleware", package: "AuthorizationMiddleware"),
				.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
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
