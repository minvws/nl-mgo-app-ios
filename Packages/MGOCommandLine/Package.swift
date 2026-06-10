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
		.package(url: "https://github.com/apple/example-package-figlet", revision: "166eef46de0b094d6d1966e749f727d6c4beba0e"),
		.package(url: "https://github.com/apple/swift-argument-parser", exact: "1.8.2")
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
