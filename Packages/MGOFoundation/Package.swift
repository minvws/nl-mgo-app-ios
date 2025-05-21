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
		.package(name: "FeatureFlag", path: "../FeatureFlag"),
		.package(name: "JailBreakDetector", path: "../JailBreakDetector"),
		.package(name: "LocalAuthenticationProvider", path: "../LocalAuthenticationProvider"),
		.package(name: "LocalisationService", path: "../LocalisationService"),
		.package(name: "MGODebug", path: "../MGODebug"),
		.package(name: "MGORepository", path: "../MGORepository"),
		.package(name: "NotificationCenter", path: "../NotificationCenter"),
		.package(name: "Observatory", path: "../Observatory"),
		.package(name: "Sanitizer", path: "../Sanitizer"),
		.package(name: "SecureUserSettings", path: "../SecureUserSettings"),
		.package(name: "RemoteAuthentication", path: "../RemoteAuthentication"),
		.package(name: "RemoteConfiguration", path: "../RemoteConfiguration"),
		
		// External
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", exact: "9.1.0"),
	],
	targets: [
		.target(
			name: "MGOFoundation",
			dependencies: [
				.product(name: "FeatureFlag", package: "FeatureFlag"),
				.product(name: "JailBreakDetector", package: "JailBreakDetector"),
				.product(name: "LocalAuthenticationProvider", package: "LocalAuthenticationProvider"),
				.product(name: "LocalisationService", package: "LocalisationService"),
				.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "MGORepository", package: "MGORepository"),
				.product(name: "NotificationCenter", package: "NotificationCenter"),
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
