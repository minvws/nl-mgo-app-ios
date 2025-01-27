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
		
		// External
		.package(url: "https://github.com/scinfu/SwiftSoup", exact: "2.7.7"),
		
		// Testing:
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "Managers",
			dependencies: [
				"SwiftSoup"
			]
		),
		.testTarget(
			name: "ManagersTests",
			dependencies: [
				"Managers",
					.product(name: "MGOTest", package: "MGOTest")
				]
			)
	]
)
