// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SecureUserSettings",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "SecureUserSettings",
			targets: ["SecureUserSettings"]),
	],
	dependencies: [
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "SecureUserSettings"
		),
		.testTarget(
			name: "SecureUserSettingsTests",
			dependencies: [
				"SecureUserSettings",
					.product(name: "MGOTest", package: "MGOTest")
				]
			)
	]
)
