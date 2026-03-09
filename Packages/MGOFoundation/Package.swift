// swift-tools-version: 6.2
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
		.package(name: "MGODebug", path: "../MGODebug"),
		.package(name: "MGORepository", path: "../MGORepository"),
		.package(name: "NetworkAvailability", path: "../NetworkAvailability"),
		.package(name: "NotificationCenter", path: "../NotificationCenter"),
		.package(name: "Observatory", path: "../Observatory"),
		.package(name: "OrganizationSearch", path: "../OrganizationSearch"),
		.package(name: "PatientFriendlyTerms", path: "../PatientFriendlyTerms"),
		.package(name: "Sanitizer", path: "../Sanitizer"),
		.package(name: "SecureUserSettings", path: "../SecureUserSettings"),
		.package(name: "RemoteAuthentication", path: "../RemoteAuthentication"),
		.package(name: "RemoteConfiguration", path: "../RemoteConfiguration"),
		
		// External
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", exact: "9.1.0"),
		.package(url: "https://github.com/hmlongco/Factory", exact: "2.5.3")
	],
	targets: [
		.target(
			name: "MGOFoundation",
			dependencies: [
				.product(name: "FactoryKit", package: "Factory"),
				.product(name: "FeatureFlag", package: "FeatureFlag"),
				.product(name: "JailBreakDetector", package: "JailBreakDetector"),
					.product(name: "MGODebug", package: "MGODebug"),
				.product(name: "MGORepository", package: "MGORepository"),
				.product(name: "NetworkAvailability", package: "NetworkAvailability"),
				.product(name: "NotificationCenter", package: "NotificationCenter"),
				.product(name: "Observatory", package: "Observatory"),
				.product(name: "OrganizationSearch", package: "OrganizationSearch"),
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
				.product(name: "PatientFriendlyTerms", package: "PatientFriendlyTerms"),
				.product(name: "Sanitizer", package: "Sanitizer"),
				.product(name: "SecureUserSettings", package: "SecureUserSettings"),
				.product(name: "RemoteConfiguration", package: "RemoteConfiguration"),
				.product(name: "RemoteAuthentication", package: "RemoteAuthentication")
			],
			)
	]
)
