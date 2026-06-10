/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
import MGOFoundation
import MGOUI
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthCategoryRecordSorterTests {

	// MARK: - Fixtures

	private let organization = Generator.healthcareOrganization("org-1")

	init() {
		_ = setupServicesSpies()
	}

	/// Captures invocations of `makeRowAction` and the closures it returns,
	/// so tests can assert that the sorter wires both correctly.
	@MainActor
	private final class ActionRecorder {
		var madeFor: [(resource: MgoResource, uiSchema: HealthUISchema, organizationId: String)] = []
		var actionInvocations = 0
	}

	private func makeSut(
		category: SharedHealthCategories.Category,
		recorder: ActionRecorder = ActionRecorder()
	) -> HealthCategoryRecordSorter {

		HealthCategoryRecordSorter(
			category: category,
			resolveOrganization: { [organization] id in
				id == organization.identifier ? organization : nil
			},
			makeRowAction: { resource, uiSchema, organizationId in
				recorder.madeFor.append((resource, uiSchema, organizationId))
				return { recorder.actionInvocations += 1 }
			}
		)
	}

	private func medicationCategory() throws -> SharedHealthCategories.Category {
		try #require(try SharedHealthCategories().findCategory(id: "medication"))
	}

	private func documentsCategory() throws -> SharedHealthCategories.Category {
		try #require(try SharedHealthCategories().findCategory(id: "documents"))
	}

	private func record(
		resources: [Data] = [],
		error: Int? = nil,
		categoryId: String = "medication",
		organizationId: String? = nil
	) -> MgoResourceRecord {

		MgoResourceRecord(
			categoryId: categoryId,
			organizationId: organizationId ?? organization.identifier,
			resources: resources,
			error: error
		)
	}

	// MARK: - Empty / error-only inputs

	@Test("Empty records produce no blocks and no errors in regular layout")
	func emptyRecords_regular_returnsEmptyResult() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())

		// When
		let result = sut.sort(records: [], type: .regular)

		// Then
		#expect(result.blocks.isEmpty)
		#expect(result.clientError == false)
		#expect(result.serverError == false)
	}

	@Test("Empty records produce no blocks and no errors in timeline layout")
	func emptyRecords_timeline_returnsEmptyResult() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())

		// When
		let result = sut.sort(records: [], type: .timeline)

		// Then
		#expect(result.blocks.isEmpty)
		#expect(result.clientError == false)
		#expect(result.serverError == false)
	}

	@Test("Client error flag propagates from a record without resources")
	func clientErrorRecord_setsClientErrorFlag() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let records = [record(error: ResourceRepositoryError.client.rawValue)]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then
		#expect(result.blocks.isEmpty)
		#expect(result.clientError == true)
		#expect(result.serverError == false)
	}

	@Test("Server error flag propagates from a record without resources")
	func serverErrorRecord_setsServerErrorFlag() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let records = [record(error: ResourceRepositoryError.server.rawValue)]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then
		#expect(result.blocks.isEmpty)
		#expect(result.clientError == false)
		#expect(result.serverError == true)
	}

	@Test("Client and server errors aggregate across multiple records")
	func clientAndServerErrors_aggregateAcrossRecords() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let records = [
			record(error: ResourceRepositoryError.client.rawValue),
			record(error: ResourceRepositoryError.server.rawValue)
		]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then
		#expect(result.clientError == true)
		#expect(result.serverError == true)
	}

	@Test("Error flags are sticky even when matching resources also produce rows")
	func errorAndRowsTogether_keepsErrorFlagAndRows() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [
			record(resources: [resource]),
			record(resources: [], error: ResourceRepositoryError.server.rawValue)
		]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then
		#expect(result.serverError == true)
		#expect(result.clientError == false)
		#expect(result.blocks.flatMap { $0.rows }.isEmpty == false)
	}

	// MARK: - Regular layout

	@Test("Regular layout produces one block per matched subcategory heading")
	func regular_singleMatchingResource_producesOneBlock() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource])]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then — only the zib_medication_use subcategory matched
		#expect(result.blocks.count == 1)
		let block = try #require(result.blocks.first)
		#expect(block.heading == String(localized: "zib_medication_use.heading"))
		#expect(block.rows.count == 1)
	}

	@Test("Regular layout filters out resources whose profile does not match the category")
	func regular_resourceWithUnmatchedProfile_isExcluded() throws {

		// Given — a category whose only profile does not match zib-MedicationUse
		let category = SharedHealthCategories.Category(
			id: "test-only",
			heading: "test.heading",
			subheading: "test.subheading",
			subcategories: [
				SharedHealthCategories.SubCategory(
					heading: "test.sub",
					profiles: ["http://example.com/fhir/StructureDefinition/Unrelated"]
				)
			]
		)
		let sut = makeSut(category: category)
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource], categoryId: "test-only")]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then
		#expect(result.blocks.isEmpty)
		#expect(result.clientError == false)
		#expect(result.serverError == false)
	}

	@Test("Regular layout merges multiple matching resources into the same subcategory block")
	func regular_multipleMatchingResources_mergeIntoOneBlock() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [
			record(resources: [resource, resource]),
			record(resources: [resource], organizationId: "org-1")
		]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then — three rows funnel into the one matching subcategory block
		#expect(result.blocks.count == 1)
		#expect(result.blocks.first?.rows.count == 3)
	}

	// MARK: - Action wiring

	@Test("makeRowAction is called per matched row with the resource, uiSchema, and organizationId")
	func regular_makeRowActionInvokedWithCorrectArguments() throws {

		// Given
		let recorder = ActionRecorder()
		let sut = makeSut(category: try medicationCategory(), recorder: recorder)
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource])]

		// When
		_ = sut.sort(records: records, type: .regular)

		// Then
		#expect(recorder.madeFor.count == 1)
		let invocation = try #require(recorder.madeFor.first)
		#expect(invocation.resource == resource)
		#expect(invocation.organizationId == organization.identifier)
		#expect(invocation.uiSchema.label == "Zestril tablet 10mg")
	}

	@Test("Invoking the row's action runs the closure produced by makeRowAction")
	func regular_invokingRowAction_runsProducedClosure() throws {

		// Given
		let recorder = ActionRecorder()
		let sut = makeSut(category: try medicationCategory(), recorder: recorder)
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource])]
		let result = sut.sort(records: records, type: .regular)
		let row = try #require(result.blocks.first?.rows.first)

		// When
		row.action?()

		// Then
		#expect(recorder.actionInvocations == 1)
	}

	@Test("Row's organization name reflects what resolveOrganization returns")
	func regular_resolveOrganization_appliedToRow() throws {

		// Given
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource])]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then — the row's subHeading carries the resolved organization name
		let row = try #require(result.blocks.first?.rows.first)
		#expect(row.subHeading == organization.name)
	}

	@Test("Unknown organization id still produces a row, without the resolved name in subHeading")
	func regular_unknownOrganization_stillProducesRow() throws {

		// Given — record with an organization id the resolver can't find
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource], organizationId: "unknown")]

		// When
		let result = sut.sort(records: records, type: .regular)

		// Then — the row is produced and its subHeading is not the org's name
		let row = try #require(result.blocks.first?.rows.first)
		#expect(row.subHeading != organization.name)
	}

	// MARK: - Timeline layout

	@Test("Timeline layout collects rows whose profile has no resolver into the unknown-date block")
	func timeline_resourceWithoutResolver_goesToUnknownDateBlock() throws {

		// Given — zib-MedicationUse has no entry in TimelineDateResolversMap.registry
		let sut = makeSut(category: try medicationCategory())
		let resource = try getResource("zibMedicationUse")
		let records = [record(resources: [resource])]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 1)
		let block = try #require(result.blocks.first)
		#expect(block.heading == String(localized: "common.unknown_date"))
		#expect(block.rows.count == 1)
	}

	@Test("Timeline layout creates one block per distinct day, sorted newest first")
	func timeline_groupsRowsByDay_sortedDescending() throws {

		// Given — a category with the IheMhd profile so its resolver is consulted
		let sut = makeSut(category: try documentsCategory())
		let records = [
			record(
				resources: [
					HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z"),
					HCIMGenerator.iheMhdJson(indexedValue: "2026-04-20T08:30:00Z")
				],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then — newest day first, one row each
		#expect(result.blocks.count == 2)
		#expect(result.blocks[0].rows.count == 1)
		#expect(result.blocks[1].rows.count == 1)
		let aprilTwentyTwo = try #require(ISO8601DateFormatter().date(from: "2026-04-22T00:00:00Z"))
		let aprilTwenty = try #require(ISO8601DateFormatter().date(from: "2026-04-20T00:00:00Z"))
		#expect(result.blocks[0].heading == HealthCategoryRecordSorter.timelineDateFormatter.string(from: aprilTwentyTwo))
		#expect(result.blocks[1].heading == HealthCategoryRecordSorter.timelineDateFormatter.string(from: aprilTwenty))
	}

	@Test("Timeline layout merges rows that share the same day into one block")
	func timeline_mergesRowsOnSameDay() throws {

		// Given — two rows whose resolved dates fall on the same calendar day
		let sut = makeSut(category: try documentsCategory())
		let records = [
			record(
				resources: [
					HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z"),
					HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T19:00:00Z")
				],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 1)
		#expect(result.blocks.first?.rows.count == 2)
	}

	@Test("Timeline layout uses 'today' heading for resources dated on the reference day")
	func timeline_todayBlock_usesTodayHeading() throws {

		// Given — `Container.shared.now` is registered to 2025-06-15 by setupServicesSpies()
		let sut = makeSut(category: try documentsCategory())
		let records = [
			record(
				resources: [HCIMGenerator.iheMhdJson(indexedValue: "2025-06-15T08:00:00Z")],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 1)
		#expect(result.blocks.first?.heading == String(localized: "common.today"))
	}

	@Test("Timeline layout uses 'yesterday' heading for resources dated the day before the reference day")
	func timeline_yesterdayBlock_usesYesterdayHeading() throws {

		// Given — `Container.shared.now` is registered to 2025-06-15 by setupServicesSpies()
		let sut = makeSut(category: try documentsCategory())
		let records = [
			record(
				resources: [HCIMGenerator.iheMhdJson(indexedValue: "2025-06-14T08:00:00Z")],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 1)
		#expect(result.blocks.first?.heading == String(localized: "common.yesterday"))
	}

	@Test("Timeline layout keeps the formatted date heading for older resources")
	func timeline_olderBlock_usesFormattedHeading() throws {

		// Given — a resource indexed several days before the registered fixed now (2025-06-15)
		let sut = makeSut(category: try documentsCategory())
		let olderIso = "2025-06-10T08:00:00Z"
		let records = [
			record(
				resources: [HCIMGenerator.iheMhdJson(indexedValue: olderIso)],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 1)
		let olderDate = try #require(ISO8601DateFormatter().date(from: olderIso))
		let day = HealthCategoryRecordSorter.timelineCalendar.startOfDay(for: olderDate)
		#expect(result.blocks.first?.heading == HealthCategoryRecordSorter.timelineDateFormatter.string(from: day))
	}

	@Test("Timeline layout appends the unknown-date block after the dated blocks")
	func timeline_unknownDateBlock_appendedLast() throws {

		// Given — one resource with a date and one without
		let sut = makeSut(category: try documentsCategory())
		let records = [
			record(
				resources: [
					HCIMGenerator.iheMhdJson(indexedValue: "2026-04-22T08:30:00Z"),
					HCIMGenerator.iheMhdJson(indexedValue: nil)
				],
				categoryId: "documents"
			)
		]

		// When
		let result = sut.sort(records: records, type: .timeline)

		// Then
		#expect(result.blocks.count == 2)
		#expect(result.blocks.last?.heading == String(localized: "common.unknown_date"))
		#expect(result.blocks.last?.rows.count == 1)
	}
}
