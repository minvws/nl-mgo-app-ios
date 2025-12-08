// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NetworkAvailability",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "NetworkAvailability",
			targets: ["NetworkAvailability"]
		)
	],
	targets: [
		.target(
			name: "NetworkAvailability"
		)
	]
)
