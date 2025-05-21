// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FeatureFlag",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "FeatureFlag",
			targets: ["FeatureFlag"]),
	],
	dependencies: [
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "FeatureFlag"
		),
		.testTarget(
			name: "FeatureFlagTests",
			dependencies: [
				"FeatureFlag",
					.product(name: "MGOTest", package: "MGOTest")
				]
			)
	]
)
