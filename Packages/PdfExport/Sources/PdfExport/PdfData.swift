/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/**
 * Represents a table row par, containing a key and a value
 */
public struct PdfSubTablePair: Equatable, Codable, Hashable {
	
	/// Create a table row pair
	/// - Parameters:
	///   - key: the row key
	///   - value: the row value
	public init(key: String, value: String) {
		self.key = key
		self.value = value
	}
	
	/// The row key
	public var key: String
	
	/// The row value
	public var value: String
}

/**
 * Represents a sub-section of a table, used to break down complex data.
 */
public struct PdfSubTable: Equatable, Codable, Hashable {
	
	/// Create a PDF sub table (i.e. a small section of the table)
	/// - Parameters:
	///   - heading: the heading for this section
	///   - data: a list of key-value pairs
	public init(heading: String? = nil, data: [PdfSubTablePair]) {
		self.heading = heading
		self.data = data
	}
	
	/// The optional title of a subtable. Could be nil if not applicable
	public let heading: String?
	
	/// A list of key-value pairs representing the subtable’s content rows.
	/// Each pair corresponds to a label (left column) and its value (right column).
	public var data: [PdfSubTablePair]
}

/**
 * Represents a single table in the PDF, possibly composed of multiple subtables.
 */
public struct PdfTable: Equatable, Codable, Hashable {
	
	/// Create a PDF table for a MGO resource
	/// - Parameters:
	///   - heading: the title of the resource
	///   - subTables: a list of sub tables for each section
	public init(heading: String, subTables: [PdfSubTable]) {
		self.heading = heading
		self.subTables = subTables
	}
	
	/// The title of the table.
	public let heading: String
	
	/// A list of subtables that make up the full table structure.
	public var subTables: [PdfSubTable]
}

/**
 * Represents a logical grouping of tables under a common heading within the PDF.
 */
public struct PdfGroupedTables: Equatable, Codable, Hashable {
	
	/// Create a PDF Grouped Table, containing all the tables for a category
	/// - Parameters:
	///   - heading: the title of the grouped table (sub category title)
	///   - tables: a list of tables for each sub categories of that category
	public init(heading: String, tables: [PdfTable]) {
		self.heading = heading
		self.tables = tables
	}
	
	/// The title for this group of tables.
	public let heading: String
	
	/// A list of individual tables included in this group.
	public var tables: [PdfTable]
}

/**
 * Represents the complete content structure of a PDF document.
 */
public struct PdfData: Equatable, Codable, Hashable {
	
	/// Create an object that holds all the data for a PDF
	/// - Parameters:
	///   - heading: the title of the PDF
	///   - subHeading: the subtitle
	///   - tables: a list of grouped tables for each category
	///   - footer: a footer for each page
	public init(heading: String, subHeading: String, tables: [PdfGroupedTables], footer: String) {
		self.heading = heading
		self.subHeading = subHeading
		self.tables = tables
		self.footer = footer
	}
	
	/// The main title displayed at the top of the PDF.
	public let heading: String
	
	/// A subtitle providing additional context or description.
	public let subHeading: String
	
	/// A list of grouped tables, each with its own heading and associated tables.
	public var tables: [PdfGroupedTables]
	
	/// A footer text displayed at the bottom of the PDF.
	public let footer: String
}
