// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CopyImport",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	dependencies: [
		// Internal
		.package(name: "MGOCommandLine", path: "../MGOCommandLine"),
	],
	targets: [
		.executableTarget(
			name: "CopyImport",
			dependencies: [
				.product(name: "MGOCommandLine", package: "MGOCommandLine"),
			],
			path: "Sources"
		)
	]
)
