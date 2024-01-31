// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOUI",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGOUI",
			targets: ["MGOUI"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "RijksoverheidFont", path: "../RijksoverheidFont"),
	],
	targets: [
		.target(
			name: "MGOUI",
			dependencies: [
				.product(name: "RijksoverheidFont", package: "RijksoverheidFont"),
			]
		)
	]
)
