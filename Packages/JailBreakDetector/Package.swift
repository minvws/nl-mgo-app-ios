// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "JailBreakDetector",
	platforms: [.iOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "JailBreakDetector",
			targets: ["JailBreakDetector"]),
	],
	dependencies: [
		// External
		.package(url: "https://github.com/securing/IOSSecuritySuite", from: "1.9.11"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "JailBreakDetector",
			dependencies: [
				.product(name: "IOSSecuritySuite", package: "IOSSecuritySuite"),
			]
		),
		.testTarget(
			name: "JailBreakDetectorTests",
			dependencies: [
				"JailBreakDetector",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
