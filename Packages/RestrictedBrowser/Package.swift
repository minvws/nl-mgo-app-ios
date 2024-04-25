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
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.16.0"),
		.package(url: "https://github.com/Quick/Nimble", from: "13.3.0"),
		.package(url: "https://github.com/nalexn/ViewInspector", exact: "0.9.10")
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
				.product(name: "Nimble", package: "Nimble"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "ViewInspector", package: "ViewInspector")
			])
	]
)
