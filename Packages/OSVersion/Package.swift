// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OSVersion",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "OSVersion",
			targets: ["OSVersion"]
		),
	],
	targets: [
		.target(
			name: "OSVersion"
		),
		.testTarget(
			name: "OSVersionTests",
			dependencies: [
				"OSVersion"
			]
		),
	]
)
