/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Figlet
import ArgumentParser
import GitHubRestAPIActions
import OpenAPIRuntime
import OpenAPIURLSession
import Foundation
import AuthorizationMiddleware

@main
struct GitHubArtefactDownload: AsyncParsableCommand {
	
	// MARK: Input Variables
	
	@Option(help: "The GitHub API token")
	public var token: String
	
	@Option(help: "The owner of the repository")
	public var owner: String
	
	@Option(help: "The repository to fetch the latest artefact from")
	public var repository: String
	
	@Option(help: "The WorkFlow ID")
	public var workflowID: String
	
	@Option(help: "The file to write the artefact to")
	public var output: String
	
	// MARK: Script
	
	/// Run this script
	public func run() async throws {
		
		Figlet.say("GitHub Artefact Download")
		
		// Create GitHub API Client
		let middleware = BearerAuthorizationMiddleware(token: token)
		let client = Client(serverURL: try Servers.server1(), transport: URLSessionTransport(), middlewares: [middleware])
		
		// Step 1: Fetch run id from the latest merge into main
		let runID = try await getRunID(client)
		print("getRunID: \(runID)") // swiftlint:disable:this disable_print
		
		// Step 2: Fetch the artefact id for that run
		let artefactID = try await getArtefactID(client, runID: runID)
		print("getArtefactID: \(artefactID)") // swiftlint:disable:this disable_print
		
		// Step 3: Fetch artefact
		try await getArtefact(client, artefactID: artefactID)
		
		print("done") // swiftlint:disable:this disable_print
	}
	
	// MARK: Helper methods
	
	/// Get the id of the run for the latest merge into main
	/// - Parameter client: the api client
	/// - Returns: the id of the workflow run
	private func getRunID(_ client: Client) async throws -> Int {
		
		let input = Operations.actions_sol_list_hyphen_workflow_hyphen_runs.Input(
			path: Operations.actions_sol_list_hyphen_workflow_hyphen_runs.Input.Path(
				owner: owner,
				repo: repository,
				workflow_id: Components.Parameters.workflow_hyphen_id.case2(workflowID)
			),
			query: Operations.actions_sol_list_hyphen_workflow_hyphen_runs.Input.Query(
				branch: "main",
				status: Components.Parameters.workflow_hyphen_run_hyphen_status.completed
			)
		)
	
		let result = try await client.actions_sol_list_hyphen_workflow_hyphen_runs(input)
		if let runID = try result.ok.body.json.workflow_runs.first?.id {
			return runID
		}
		fatalError("No workflow id found")
	}
	
	/// Get the id of the artefact for a run
	/// - Parameters:
	///   - client: the api client
	///   - runID: the id of the run
	/// - Returns: the id of the artefact
	private func getArtefactID(_ client: Client, runID: Int) async throws -> Int {
		
		let input = Operations.actions_sol_list_hyphen_workflow_hyphen_run_hyphen_artifacts.Input(
			path: Operations.actions_sol_list_hyphen_workflow_hyphen_run_hyphen_artifacts.Input.Path(
				owner: owner,
				repo: repository,
				run_id: runID
			)
		)
		let result = try await client.actions_sol_list_hyphen_workflow_hyphen_run_hyphen_artifacts(input)
		if let artefactID = try result.ok.body.json.artifacts.first?.id {
			return artefactID
		}
		fatalError("No artefact id found")
	}
	
	func getArtefact(_ client: Client, artefactID: Int) async throws {
		
		let input = Operations.actions_sol_download_hyphen_artifact.Input(
			path: Operations.actions_sol_download_hyphen_artifact.Input.Path(
				owner: owner,
				repo: repository,
				artifact_id: artefactID,
				archive_format: "zip"
			)
		)
		let result = try await client.actions_sol_download_hyphen_artifact(input)
		switch result {
			case .found(let found):
				print("found: \(found)")
			case .gone(let gone):
				print("gone: \(gone)")
			case .undocumented(let statusCode, let undocumentedPayload):
				print("undocumented: \(statusCode)")
			print("undocumentedPayload: \(undocumentedPayload.body)")
//			let buffer = try await ArraySlice(collecting: undocumentedPayload.body, upTo: 2 * 1024 * 1024)
//			let ddd = undocumentedPayload.body
			
			// Todo: Store the body into the output file
			// Todo: Fix documents after previous zib import
		}

	}
}
