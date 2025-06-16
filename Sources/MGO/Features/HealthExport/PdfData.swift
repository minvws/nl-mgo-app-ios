/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/**
 * Represents a table row par, containing a key and a value
 */
public struct PdfSubTablePair: Equatable {
	/// The row key
	var key: String
	
	/// The row value
	var value: String
}

/**
 * Represents a sub-section of a table, used to break down complex data.
 */
public struct PdfSubTable: Equatable {
	
	/// The optional title of a subtable. Could be nil if not applicable
	let heading: String?
	
	/// A list of key-value pairs representing the subtable’s content rows.
	/// Each pair corresponds to a label (left column) and its value (right column).
	var data: [PdfSubTablePair]
}

/**
 * Represents a single table in the PDF, possibly composed of multiple subtables.
 */
public struct PdfTable: Equatable {
	
	/// The title of the table.
	let heading: String
	
	/// A list of subtables that make up the full table structure.
	var subTables: [PdfSubTable]
}

/**
 * Represents a logical grouping of tables under a common heading within the PDF.
 */
public struct PdfGroupedTables: Equatable {
	
	/// The title for this group of tables.
	let heading: String
	
	/// A list of individual tables included in this group.
	var tables: [PdfTable]
}

/**
 * Represents the complete content structure of a PDF document.
 */
public struct PdfData: Equatable {
	
	/// The main title displayed at the top of the PDF.
	let heading: String
	
	/// A subtitle providing additional context or description.
	let subHeading: String
	
	/// A list of grouped tables, each with its own heading and associated tables.
	var tables: [PdfGroupedTables]
	
	/// A footer text displayed at the bottom of the PDF.
	let footer: String
}
