// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOTest",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "MGOTest",
			targets: ["MGOTest"]
		)
	],
	dependencies: [
		
		// Testing:
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.18.3"),
		.package(url: "https://github.com/Quick/Nimble", exact: "13.7.1"),
		.package(url: "https://github.com/nalexn/ViewInspector", exact: "0.10.1")
	],
	targets: [
		.target(
			name: "MGOTest",
			dependencies: [
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "Nimble", package: "Nimble"),
				.product(name: "ViewInspector", package: "ViewInspector")
			]
		)
	]
)
