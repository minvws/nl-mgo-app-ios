// swift-tools-version: 6.2
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
		.package(url: "https://github.com/scinfu/SwiftSoup", exact: "2.13.5"),
	],
	targets: [
		.target(
			name: "Sanitizer",
			dependencies: ["SwiftSoup"]
		),
		.testTarget(
			name: "SanitizerTests",
			dependencies: ["Sanitizer"]
		)
	]
)
