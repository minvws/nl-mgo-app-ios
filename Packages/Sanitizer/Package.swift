// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Sanitizer",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "Sanitizer",
			targets: ["Sanitizer"]),
	],
	dependencies: [
		
		// External
		.package(url: "https://github.com/scinfu/SwiftSoup", exact: "2.9.6"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "Sanitizer",
			dependencies: [
				"SwiftSoup"
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "SanitizerTests",
			dependencies: [
				"Sanitizer",
					.product(name: "MGOTest", package: "MGOTest")
				]
			)
	]
)
