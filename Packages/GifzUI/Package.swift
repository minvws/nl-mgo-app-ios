// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GifzUI",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "GifzUI",
			targets: ["GifzUI"]
		)
	],
	dependencies: [
		// Internal
		.package(name: "RijksoverheidFont", path: "../RijksoverheidFont"),
	],
	targets: [
		.target(
			name: "GifzUI",
			dependencies: [
				.product(name: "RijksoverheidFont", package: "RijksoverheidFont"),
			]
		),
//		.testTarget(
//			name: "GifzUITests",
//			dependencies: ["GifzUI"]
//		)
	]
)
