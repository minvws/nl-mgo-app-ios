// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MGOCommandLine",
	platforms: [
		.macOS(.v10_15), .iOS(.v15)
	],
	products: [
		.library(
			name: "MGOCommandLine",
			targets: ["MGOCommandLine"]
		)
	],
	dependencies: [
		
		// External
		.package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", exact: "1.7.0")
	],
	targets: [
		.target(
			name: "MGOCommandLine",
			dependencies: [
				.product(name: "Figlet", package: "example-package-figlet"),
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			]
		)
	]
)
