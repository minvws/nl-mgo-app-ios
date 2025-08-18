// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PatientFriendlyTerms",
	products: [
		.library(
			name: "PatientFriendlyTerms",
			targets: ["PatientFriendlyTerms"]),
	],
	targets: [
		.target(
			name: "PatientFriendlyTerms"),
		.testTarget(
			name: "PatientFriendlyTermsTests",
			dependencies: ["PatientFriendlyTerms"]
		),
	]
)
