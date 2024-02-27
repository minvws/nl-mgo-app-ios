// swift-tools-version: 5.9
//  Package.swift
//  SwiftFHIR
//
//  Created by Pascal Pfiffner on 12/10/15.
//  2015, SMART Platforms.
//

import PackageDescription

let package = Package(
	name: "FHIR",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v12)
	],
	products: [
		.library(
			name: "FHIR",
			targets: ["FHIR"]),
	],
	dependencies: [
		
		// Testing
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", exact: "9.1.0")
	],
	targets: [
		.target(
			name: "FHIR",
			dependencies: ["Models", "Client"]),
		.target(
			name: "Models",
			dependencies: []),
		.target(
			name: "Client",
			dependencies: ["Models"]),
		.testTarget(
			name: "FHIRTests",
			dependencies: [
				"FHIR",
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
			],
			resources: [.process("Resources")]
		)
	]
)
