// swift-tools-version: 5.9
//  Package.swift
//
//  Created by Dave Carlson on 8/8/19.

import PackageDescription

let package = Package(
    name: "SMART",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v12)
	],
	products: [
		.library(
			name: "SMART",
			targets: ["SMART"]
		)
	],
	dependencies: [
		//		.package(url: "https://github.com/smart-on-fhir/Swift-FHIR", exact: "3.1.1"),
		.package(name: "Swift-FHIR", path: "../Swift-FHIR"),
		.package(url: "https://github.com/p2/OAuth2", exact: "5.3.3")
	],
	targets: [
		.target(
			name: "SMART",
			dependencies: [
				.product(name: "OAuth2", package: "OAuth2"),
				.product(name: "FHIR", package: "Swift-FHIR")
			],
			path: "Sources",
			sources: ["SMART", "Client", "iOS", "macOS"])
	]
)
