// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Managers",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "Managers",
			targets: ["Managers"]),
	],
	dependencies: [
		
		// Testing:
		.package(url: "https://github.com/Quick/Nimble", exact: "13.2.0")
	],
	targets: [
		.target(
			name: "Managers"
		),
		.testTarget(
			name: "ManagersTests",
			dependencies: [
				"Managers",
					.product(name: "Nimble", package: "Nimble")
				]
			)
	]
)
