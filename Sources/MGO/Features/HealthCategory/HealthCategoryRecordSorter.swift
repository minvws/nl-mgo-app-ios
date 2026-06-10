/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// Aggregated output of `HealthCategoryRecordSorter.sort(records:type:)`.
///
/// `clientError` and `serverError` are sticky flags: they are `true` if any
/// of the input records carried the corresponding error code, regardless of
/// whether the record also produced visible rows. This lets the view model
/// decide between a hard-error state and a partial-error state.
struct HealthCategorySortResult: Equatable {
	
	/// The blocks to render, already grouped and ordered for display.
	let blocks: [HealthCategoryBlock]
	
	/// `true` if any record reported a client-side error.
	let clientError: Bool
	
	/// `true` if any record reported a server-side error.
	let serverError: Bool
}

/// Transforms `MgoResourceRecord`s loaded from the data store into the
/// `HealthCategoryBlock` collection rendered by `HealthCategoryView`.
///
/// The sorter encapsulates the logic that previously lived on
/// `HealthCategoryViewModel`:
/// - filtering each record's resources to those declaring an accepted FHIR
///   profile for the current category,
/// - parsing matching resources into `HealthCategoryRow`s via `HCIMParser`,
/// - grouping rows either by subcategory (`.regular`) or by day (`.timeline`),
/// - and propagating client / server error flags found on the input records.
///
/// It is deliberately stateless aside from the injected closures: a fresh
/// instance is created for each sort pass by the view model. Coordinator
/// routing is kept out of the sorter by injecting `makeRowAction`, which
/// the view model implements in terms of its `Coordinator`. Organization
/// resolution is similarly injected via `resolveOrganization` so the sorter
/// does not depend on `HealthcareOrganizationRepository` directly.
///
/// The type is `@MainActor` because `HCIMParser` and the row tap actions
/// produced here interact with main-actor isolated state.
@MainActor
struct HealthCategoryRecordSorter {
	
	/// The category whose subcategories drive profile filtering and the
	/// section headings in the regular layout.
	let category: SharedHealthCategories.Category
	
	/// Resolves an organization id to its `Organization` model, or `nil` if
	/// the organization is no longer known to the repository.
	let resolveOrganization: (String) -> OrganizationSearch.Organization?
	
	/// Builds the on-tap action attached to each row.
	///
	/// Called once per resulting row with the source resource, its parsed
	/// UI schema and the owning organization id. The view model uses this
	/// hook to route to the health data detail screen via its coordinator.
	let makeRowAction: (MgoResource, HealthUISchema, String) -> () -> Void

	/// HCIM parser used to derive summary / card info from each raw resource.
	private let parser = HCIMParser()
	
	/// Calendar used to bucket timeline entries by day in the user's local
	/// timezone (Europe/Amsterdam, falling back to the device's current zone).
	static let timelineCalendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam") ?? .current
		return calendar
	}()
	
	/// Long Dutch date format for timeline section headings (e.g. "7 mei 2026").
	static let timelineDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "nl")
		formatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()
	
	/// A row that survived profile filtering and parsing, paired with the
	/// context the layout step needs to bucket it.
	private struct ParsedRow {
		
		/// The displayable row.
		let row: HealthCategoryRow
		
		/// The source resource — needed by the timeline layout to resolve the row's date.
		let resource: MgoResource
		
		/// The profile that matched for this resource — keyed input to the timeline date lookup.
		let profile: String
		
		/// The subcategory the row was produced under — drives heading for the regular layout.
		let subcategory: SharedHealthCategories.SubCategory
	}
	
	/// Sort `records` into displayable blocks using the requested layout.
	///
	/// Parsing and error-flag aggregation are shared across layouts; only the
	/// bucketing step differs per `type`.
	///
	/// - Parameters:
	///   - records: the resource records loaded from the data store.
	///   - type: `.regular` groups rows by subcategory; `.timeline` groups
	///     rows by the day of their `TimelineDateResolver.timelineDateValue`, with a
	///     trailing "unknown date" block for rows whose source carries no date.
	/// - Returns: the produced blocks plus aggregated client / server error flags.
	func sort(
		records: [MgoResourceRecord],
		type: HealthCategoryViewType
	) -> HealthCategorySortResult {
		
		let parsedRows = parseRows(records: records, type: type)
		let blocks: [HealthCategoryBlock] = {
			switch type {
				case .timeline: return groupByDay(parsedRows)
				case .regular: return groupBySubcategory(parsedRows)
			}
		}()
		let errors = errorFlags(for: records)
		return HealthCategorySortResult(blocks: blocks, clientError: errors.client, serverError: errors.server)
	}
	
	/// Walk every `(subcategory, profile, record, resource)` combination and
	/// return the rows that pass profile filtering and parse successfully.
	///
	/// This is the single place where the source records are traversed and
	/// rows are constructed; both layouts then operate on the resulting flat
	/// list, which keeps the bucketing functions focused on the work that
	/// actually differs between them.
	private func parseRows(
		records: [MgoResourceRecord],
		type: HealthCategoryViewType
	) -> [ParsedRow] {

		var parsed: [ParsedRow] = []
		for subcategory in category.subcategories {
			for profile in subcategory.profiles {
				for record in records {
					for resource in record.resources {
						if let row = parseRecordResource(
							resource,
							organizationId: record.organizationId,
							acceptedProfile: profile,
							type: type
						) {
							parsed.append(ParsedRow(row: row, resource: resource, profile: profile, subcategory: subcategory))
						}
					}
				}
			}
		}
		return parsed
	}
	
	/// Aggregate sticky client / server error flags from the input records.
	///
	/// A record contributes its flag regardless of whether it produced any
	/// visible rows, so the caller can detect partial-error states.
	private func errorFlags(
		for records: [MgoResourceRecord]
	) -> (client: Bool, server: Bool) {
		(
			records.contains { $0.error == ResourceRepositoryError.client.rawValue },
			records.contains { $0.error == ResourceRepositoryError.server.rawValue }
		)
	}
	
	/// Group parsed rows by the day of their `timelineDateValue`, newest day first.
	///
	/// Rows whose source resource has no resolvable date are collected into
	/// a single trailing block headed by `common.unknown_date`.
	private func groupByDay(
		_ parsedRows: [ParsedRow]
	) -> [HealthCategoryBlock] {

		let today = Self.timelineCalendar.startOfDay(for: Container.shared.now()())
		let yesterday = Self.timelineCalendar.date(byAdding: .day, value: -1, to: today)
		var blocksByDay: [Date: HealthCategoryBlock] = [:]
		var unknownDateRows: [HealthCategoryRow] = []

		for parsed in parsedRows {
			guard let date = TimelineDateResolversMap.make(profile: parsed.profile, data: parsed.resource)?.timelineDateValue else {
				unknownDateRows.append(parsed.row)
				continue
			}
			let day = Self.timelineCalendar.startOfDay(for: date)
			if blocksByDay[day] != nil {
				blocksByDay[day]?.rows.append(parsed.row)
			} else {
				let heading: String
				if day == today {
					heading = String(localized: "common.today")
				} else if day == yesterday {
					heading = String(localized: "common.yesterday")
				} else {
					heading = Self.timelineDateFormatter.string(from: day)
				}
				blocksByDay[day] = HealthCategoryBlock(
					heading: heading,
					rows: [parsed.row]
				)
			}
		}

		var items = blocksByDay.keys.sorted(by: >).compactMap { blocksByDay[$0] }
		if !unknownDateRows.isEmpty {
			items.append(
				HealthCategoryBlock(
					heading: String(localized: "common.unknown_date"),
					rows: unknownDateRows,
					isUnknownDate: true
				)
			)
		}
		return items
	}
	
	/// Group parsed rows by subcategory heading.
	///
	/// Subcategories sharing the same localized heading are merged into one
	/// block (a category can declare the same heading across multiple
	/// profile filters). Block order follows first appearance in
	/// `parsedRows`, which matches the iteration order of
	/// `category.subcategories` × `subcategory.profiles`.
	private func groupBySubcategory(
		_ parsedRows: [ParsedRow]
	) -> [HealthCategoryBlock] {
		
		var items: [HealthCategoryBlock] = []
		var indexByHeading: [String: Int] = [:]
		
		for parsed in parsedRows {
			let heading = parsed.subcategory.localized()
			if let index = indexByHeading[heading] {
				items[index].rows.append(parsed.row)
			} else {
				indexByHeading[heading] = items.count
				items.append(
					HealthCategoryBlock(
						heading: heading,
						rows: [parsed.row]
					)
				)
			}
		}
		return items
	}
	
	/// Build a displayable row from a single resource, if it matches the accepted profile.
	/// - Parameters:
	///   - resource: the resource to parse.
	///   - organizationId: identifier of the organization that owns the
	///     resource, used to resolve the organization name and to wire the
	///     row's tap action.
	///   - acceptedProfile: profile filter; the resource is skipped when it
	///     does not declare this profile.
	/// - Returns: a `HealthCategoryRow` with parsed card info and the tap
	///   action produced by `makeRowAction`, or `nil` when the profile does
	///   not match or the parser cannot produce a summary or card.
	private func parseRecordResource(
		_ resource: MgoResource,
		organizationId: String,
		acceptedProfile: String,
		type: HealthCategoryViewType
	) -> HealthCategoryRow? {

		guard resource.hasProfile(acceptedProfile) else { return nil }
		let organizationName = Sanitizer.strip(resolveOrganization(organizationId)?.name)
		guard
			let uiSchema = parser.getSummary(resource, organizationName: organizationName),
			let cardInfo = parser.getCard(resource, organizationName: organizationName)
		else {
			return nil
		}

		return HealthCategoryRow(
			heading: Sanitizer.sanitize(cardInfo.title),
			subHeading: cardInfo.description,
			schema: uiSchema,
			details: type == .timeline ? nil : cardInfo.detail,
			action: makeRowAction(resource, uiSchema, organizationId)
		)
	}
}
