// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PatientFriendlyTerms",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "PatientFriendlyTerms",
			targets: ["PatientFriendlyTerms"]),
	],
	dependencies: [
		// Internal
		.package(name: "AuthorizationMiddleware", path: "../AuthorizationMiddleware"),
		.package(name: "FileStorage", path: "../FileStorage"),
		.package(name: "MGODebug", path: "../MGODebug"),
		
		// External
		.package(url: "https://github.com/apple/swift-openapi-generator", exact: "1.10.4"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", exact: "1.11.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", exact: "1.2.0"),
		.package(url: "https://github.com/jessesquires/Foil.git", exact: "6.1.0"),
		
		// Testing
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0")
	],
	targets: [
		.target(
			name: "PatientFriendlyTerms",
			dependencies: [
				.product(name: "AuthorizationMiddleware", package: "AuthorizationMiddleware"),
				.product(name: "FileStorage", package: "FileStorage"),
				.product(name: "Foil", package: "Foil"),
				.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			],
			plugins: [
				.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
			]
		),
		.testTarget(
			name: "PatientFriendlyTermsTests",
			dependencies: [
				"PatientFriendlyTerms",
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
			]
		),
	]
)
