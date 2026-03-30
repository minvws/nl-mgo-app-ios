// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HCIMCore",
	platforms: [.iOS(.v15)],
	products: [
		// HCIMCoreModels exposes the 480 generated FHIR model types plus small companion
		// model files as a standalone product. Keeping this separate lets Xcode cache it
		// independently — a change to HCIMCore logic files does not trigger a recompile
		// of the stable generated models.
		.library(
			name: "HCIMCoreModels",
			targets: ["HCIMCoreModels"]),
		.library(
			name: "HCIMCore",
			targets: ["HCIMCore"]),
	],
	dependencies: [
		// Internal
		.package(name: "MGODebug", path: "../MGODebug"),
	],
	targets: [
		// Stable model types: 480 generated FHIR structs + small companion models.
		// Foundation-only, no other dependencies. These files rarely change.
		.target(
			name: "HCIMCoreModels",
			path: "Sources/HCIMCore",
			sources: [
				"HCIM/Generated",
				"HCIM/HCIMVersion.swift",
				"FHIR/FHIRBinary.swift",
			]
		),
		// Active logic: parser, factory, data helpers.
		// Re-exports HCIMCoreModels so callers only need to import HCIMCore.
		.target(
			name: "HCIMCore",
			dependencies: [
				"HCIMCoreModels",
				.product(name: "MGODebug", package: "MGODebug")
			],
			path: "Sources/HCIMCore",
			sources: [
				"HCIM/Data+Profile.swift",
				"HCIM/HCIMFactory.swift",
				"HCIMParser",
			],
			resources: [.process("Resources")]
		),
		.testTarget(
			name: "HCIMCoreTests",
			dependencies: ["HCIMCore"],
			resources: [.process("Resources")]
		)
	]
)
