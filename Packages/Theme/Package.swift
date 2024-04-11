// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Theme",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "Theme",
			targets: ["Theme"]),
	],
	targets: [
		.target(
			name: "Theme"),
		.testTarget(
			name: "ThemeTests",
			dependencies: ["Theme"]),
	]
)
