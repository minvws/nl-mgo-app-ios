/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOCommandLine
import GitHubRestAPIActions
import OpenAPIRuntime
import OpenAPIURLSession
import Foundation
import AuthorizationMiddleware

@main
struct GitHubArtifactDownload: AsyncParsableCommand {
	
	// MARK: Input Variables
	
	@Option(help: "The GitHub API token")
	public var token: String
	
	@Option(help: "The owner of the repository")
	public var owner: String
	
	@Option(help: "The repository to fetch the latest artifact from")
	public var repository: String
	
	@Option(help: "The branch to fetch the latest artifact from")
	public var branch: String
	
	@Option(help: "The WorkFlow ID")
	public var workflowID: String
	
	@Option(help: "The file to write the artifact to")
	public var output: String
	
	// MARK: Script
	
	/// Run this script
	public func run() async throws {
		
		Figlet.say("GitHub Artifact Download")
		
		// Create GitHub API Client
		let middleware = AuthorizationMiddleware(token: token)
		let client = Client(serverURL: try Servers.Server1.url(), transport: URLSessionTransport(), middlewares: [middleware])
		
		// Step 1: Fetch run id from the latest merge into main
		let runID = try await getRunID(client)
		print("getRunID: \(runID)") // swiftlint:disable:this disable_print
		
		// Step 2: Fetch the artifact id for that run
		let artifactID = try await getArtifactID(client, runID: runID)
		print("getArtifactID: \(artifactID)") // swiftlint:disable:this disable_print
		
		// Step 3: Download the artifact and save to the output
		try await downloadAndSaveArtifact(client, artifactID: artifactID)
		
		print("Artifact downloaded successfully to \(output)") // swiftlint:disable:this disable_print
	}
	
	// MARK: Helper methods
	
	/// Get the id of the run for the latest merge into main
	/// - Parameter client: the api client
	/// - Returns: the id of the workflow run
	private func getRunID(_ client: Client) async throws -> Int {
		
		let input = Operations.ActionsListWorkflowRuns.Input(
			path: Operations.ActionsListWorkflowRuns.Input.Path(
				owner: owner,
				repo: repository,
				workflowId: Components.Parameters.WorkflowId.case2(workflowID)
			),
			query: Operations.ActionsListWorkflowRuns.Input.Query(
				branch: branch,
				status: Components.Parameters.WorkflowRunStatus.success
			)
		)
		
		let result = try await client.actionsListWorkflowRuns(input)
		if let runID = try result.ok.body.json.workflowRuns.first?.id {
			return runID
		}
		fatalError("No workflow id found")
	}
	
	/// Get the id of the artifact for a run
	/// - Parameters:
	///   - client: the api client
	///   - runID: the id of the run
	/// - Returns: the id of the artifact
	private func getArtifactID(_ client: Client, runID: Int) async throws -> Int {
		
		let input = Operations.ActionsListWorkflowRunArtifacts.Input(
			path: Operations.ActionsListWorkflowRunArtifacts.Input.Path(
				owner: owner,
				repo: repository,
				runId: runID
			)
		)
		let result = try await client.actionsListWorkflowRunArtifacts(input)
		if let artifactID = try result.ok.body.json.artifacts.first?.id {
			return artifactID
		}
		fatalError("No artifact id found")
	}
	
	/// Download and save the artifact
	/// - Parameters:
	///   - client: theapi client
	///   - artifactID: the id of the artifact to download
	func downloadAndSaveArtifact(_ client: Client, artifactID: Int) async throws {
		
		let input = Operations.ActionsDownloadArtifact.Input(
			path: Operations.ActionsDownloadArtifact.Input.Path(
				owner: owner,
				repo: repository,
				artifactId: artifactID,
				archiveFormat: "zip"
			)
		)
		let result = try await client.actionsDownloadArtifact(input)
		switch result {
			case .found(let found):
				fatalError("No artifact: \(found)")
		
			case .gone(let gone):
				fatalError("No artifact: \(gone)")
			
			case .undocumented(let statusCode, let undocumentedPayload):
				guard statusCode == 200, let body = undocumentedPayload.body else {
					fatalError("No artifact: no http body on payload")
				}
				let buffer = try await ArraySlice(collecting: body, upTo: 2 * 1024 * 1024)
				let data = Data(buffer)
				try (data as NSData).write(toFile: output, options: .atomic)
		}
	}
}
