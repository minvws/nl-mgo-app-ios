// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RijksoverheidFont",
	platforms: [.iOS(.v14)],
	products: [
		.library(
			name: "RijksoverheidFont",
			targets: ["RijksoverheidFont"]
		),
	],
	dependencies: [
		// External
		.package(url: "https://github.com/devicekit/DeviceKit", exact: "5.2.2"),
		
		// Testing
		.package(url: "https://github.com/Quick/Nimble", exact: "13.2.1"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.15.4")
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
				.product(name: "Nimble", package: "Nimble"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
			]
		)
	]
)
