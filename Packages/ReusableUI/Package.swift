// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ReusableUI",
	platforms: [.iOS(.v14)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "ReusableUI",
			targets: ["ReusableUI"]),
	],
	dependencies: [
		// Internal
		.package(name: "Theme", path: "../Theme"),
		.package(name: "RijksoverheidFont", path: "../RijksoverheidFont"),
		
		// Testing:
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.16.0"),
		.package(url: "https://github.com/Quick/Nimble", exact: "13.3.0"),
		.package(url: "https://github.com/nalexn/ViewInspector", exact: "0.9.10")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "ReusableUI",
			dependencies: [
				.product(name: "Theme", package: "Theme"),
				.product(name: "RijksoverheidFont", package: "RijksoverheidFont"),
			]
		),
		.testTarget(
			name: "ReusableUITests",
			dependencies: [
				"ReusableUI",
				.product(name: "Nimble", package: "Nimble"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "ViewInspector", package: "ViewInspector")
			]
		)
	]
)
