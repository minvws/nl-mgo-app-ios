// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PdfExport",
	platforms: [.iOS(.v15)],
	products: [
		.library(
			name: "PdfExport",
			targets: ["PdfExport"]),
	],
	dependencies: [
		// Test
		.package(name: "MGOTest", path: "../MGOTest")
	],
	targets: [
		.target(
			name: "PdfExport",
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "PdfExportTests",
			dependencies: [
				"PdfExport",
				.product(name: "MGOTest", package: "MGOTest")
			]
		)
	]
)
