// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CopyImport",
	dependencies: [
		.package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", exact: "1.5.0")
	],
	targets: [
		.executableTarget(
			name: "CopyImport",
			dependencies: [
				.product(name: "Figlet", package: "example-package-figlet"),
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Sources"
		)
	]
)
