// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GithubArtifactDownload",
	platforms: [
		.macOS(.v10_15), .iOS(.v15)
	],
	dependencies: [
		
		// Internal
		.package(name: "AuthorizationMiddleware", path: "../AuthorizationMiddleware"),
		.package(name: "MGOCommandLine", path: "../MGOCommandLine"),
		
		// External
		.package(url: "https://github.com/wei18/github-rest-api-swift-openapi.git", exact: "3.0.4")
	],
	targets: [
		.executableTarget(
			name: "GithubArtifactDownload",
			dependencies: [
				.product(name: "AuthorizationMiddleware", package: "AuthorizationMiddleware"),
				.product(name: "MGOCommandLine", package: "MGOCommandLine"),
				.product(name: "GitHubRestAPIActions", package: "github-rest-api-swift-openapi")
			],
			path: "Sources"
		)
	]
)
