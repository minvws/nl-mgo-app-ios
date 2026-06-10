// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RestrictedBrowser",
	defaultLocalization: "nl",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "RestrictedBrowser",
			targets: ["RestrictedBrowser"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "OSVersion", path: "../OSVersion"),
		.package(name: "Theme", path: "../Theme"),
		.package(name: "ReusableUI", path: "../ReusableUI"),

		// Test
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "RestrictedBrowser",
			dependencies: [
				.product(name: "OSVersion", package: "OSVersion"),
				.product(name: "Theme", package: "Theme"),
				.product(name: "ReusableUI", package: "ReusableUI")
			],
			),
		.testTarget(
			name: "RestrictedBrowserTests",
			dependencies: [
				"RestrictedBrowser",
				.product(name: "MGOTest", package: "MGOTest")
			])
	]
)
