// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GithubArtifactDownload",
	platforms: [
		.macOS(.v10_15), .iOS(.v15)
	],
	dependencies: [
		
		// Interal
		.package(name: "AuthorizationMiddleware", path: "../AuthorizationMiddleware"),
		
		// External
		.package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", exact: "1.5.0"),
		.package(url: "https://github.com/wei18/github-rest-api-swift-openapi.git", exact: "2.0.5")
	],
	targets: [
		.executableTarget(
			name: "GithubArtifactDownload",
			dependencies: [
				.product(name: "AuthorizationMiddleware", package: "AuthorizationMiddleware"),
				.product(name: "Figlet", package: "example-package-figlet"),
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "GitHubRestAPIActions", package: "github-rest-api-swift-openapi")
			],
			path: "Sources"
		)
	]
)
