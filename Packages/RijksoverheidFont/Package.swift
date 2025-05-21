// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RijksoverheidFont",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "RijksoverheidFont",
			targets: ["RijksoverheidFont"]
		),
	],
	dependencies: [
		// External
		.package(url: "https://github.com/devicekit/DeviceKit", exact: "5.6.0"),
		
		// Testing
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "RijksoverheidFont",
			dependencies: [
				.product(name: "DeviceKit", package: "DeviceKit"),
			],
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "RijksoverheidFontTests",
			dependencies: [
				"RijksoverheidFont",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
