// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOFoundation",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGOFoundation",
			targets: ["MGOFoundation"]
		)
	],
	dependencies: [
		
		// Internal
		.package(name: "JailBreakDetector", path: "../JailBreakDetector"),
		.package(name: "LocalisationService", path: "../LocalisationService"),
		.package(name: "Managers", path: "../Managers"),
		.package(name: "MGORepository", path: "../MGORepository"),
		.package(name: "Observatory", path: "../Observatory"),
		.package(name: "Sanitizer", path: "../Sanitizer"),
		.package(name: "SecureUserSettings", path: "../SecureUserSettings"),
		.package(name: "RemoteAuthentication", path: "../RemoteAuthentication"),
		.package(name: "RemoteConfiguration", path: "../RemoteConfiguration"),
		
		// VWS
		.package(url: "https://github.com/minvws/nl-rdo-app-ios-modules", branch: "main"),
		
		// External
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", exact: "9.1.0"),
	],
	targets: [
		.target(
			name: "MGOFoundation",
			dependencies: [
				.product(name: "JailBreakDetector", package: "JailBreakDetector"),
				.product(name: "LocalisationService", package: "LocalisationService"),
				.product(name: "Logging", package: "nl-rdo-app-ios-modules"),
				.product(name: "Managers", package: "Managers"),
				.product(name: "MGORepository", package: "MGORepository"),
				.product(name: "Observatory", package: "Observatory"),
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
				.product(name: "Sanitizer", package: "Sanitizer"),
				.product(name: "SecureUserSettings", package: "SecureUserSettings"),
				.product(name: "RemoteConfiguration", package: "RemoteConfiguration"),
				.product(name: "RemoteAuthentication", package: "RemoteAuthentication")
			]
		)
	]
)
