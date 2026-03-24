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
		.package(name: "OpenAPICore", path: "../OpenAPICore"),
		.package(name: "OpenAPIMiddleware", path: "../OpenAPIMiddleware"),
		.package(name: "FileStorage", path: "../FileStorage"),
		.package(name: "MGODebug", path: "../MGODebug"),

		// External
		.package(
			url: "https://github.com/apple/swift-openapi-generator",
			exact: "1.11.1"
		),
		.package(
			url: "https://github.com/jessesquires/Foil.git",
			exact: "6.1.0"
		),
		
		// Testing
		.package(
			url: "https://github.com/AliSoftware/OHHTTPStubs",
			exact: "9.1.0"
		)
	],
	targets: [
		.target(
			name: "PatientFriendlyTerms",
			dependencies: [
				.product(name: "OpenAPICore", package: "OpenAPICore"),
				.product(name: "OpenAPIMiddleware", package: "OpenAPIMiddleware"),
				.product(name: "FileStorage", package: "FileStorage"),
				.product(name: "Foil", package: "Foil"),
				.product(name: "MGODebug", package: "MGODebug")
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
