// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NotificationCenter",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "NotificationCenter",
			targets: ["NotificationCenter"]),
	],
	targets: [
		.target(
			name: "NotificationCenter"
		)
	]
)
