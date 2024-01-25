// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GifzTest",
	products: [
		.library(
			name: "GifzTest",
			targets: ["GifzTest"]
		)
	],
	dependencies: [
		
		// Testing:
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.15.2"),
		.package(url: "https://github.com/Quick/Nimble", exact: "13.1.2")
	],
	targets: [
		.target(
			name: "GifzTest",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "Nimble", package: "Nimble")
			]
		)
	]
)
