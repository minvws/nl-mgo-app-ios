// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RestrictedBrowser",
	defaultLocalization: "nl",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "RestrictedBrowser",
			targets: ["RestrictedBrowser"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/Quick/Nimble", from: "13.2.1")
	],
	targets: [
		.target(name: "RestrictedBrowser"),
		.testTarget(
			name: "RestrictedBrowserTests",
			dependencies: [
				"RestrictedBrowser",
				.product(name: "Nimble", package: "Nimble")
			])
	]
)
