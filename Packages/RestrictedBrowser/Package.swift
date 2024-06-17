// swift-tools-version: 5.9
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
		.package(name: "Theme", path: "../Theme"),
		
		// Test
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "RestrictedBrowser",
			dependencies: [
				.product(name: "Theme", package: "Theme")
			]
		),
		.testTarget(
			name: "RestrictedBrowserTests",
			dependencies: [
				"RestrictedBrowser",
				.product(name: "MGOTest", package: "MGOTest")
			])
	]
)
