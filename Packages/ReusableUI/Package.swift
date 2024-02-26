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
		
		// Testing:
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.15.3"),
		.package(url: "https://github.com/Quick/Nimble", exact: "13.2.1"),
		.package(url: "https://github.com/nalexn/ViewInspector", exact: "0.9.10")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "ReusableUI"),
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
