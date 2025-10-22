/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

public struct SharedHealthCategories: Sendable {
	
	// MARK: - Sub Category
	
	/// A sub category is a container for a number of profiles aka accepted HCIMs
	public struct SubCategory: Codable, Equatable, Sendable, Hashable {
		
		/// The translation key for the heading of a sub category
		public let heading: String
		
		/// An array of accepted HCIMs for this subcategory
		public let profiles: [String]
		
		/// Create a sub category
		/// - Parameters:
		///   - heading: the translation key for this sub category
		///   - profiles: An array of accepted HCIMs for this subcategory
		public init(heading: String, profiles: [String]) {
			self.heading = heading
			self.profiles = profiles
		}
		
		/// Get the localized string for the heading
		/// - Returns: localized string for the heading
		public func localized() -> String {
			return String(localized: String.LocalizationValue(stringLiteral: heading))
		}
	}

	// MARK: - Category
	
	/// A category is a container of subcategories. I.E. Vaccinations, containing the sub categories
	/// vaccinations and recommended vaccinations.
	public struct Category: Codable, Equatable, Identifiable, Hashable, Sendable {
		
		/// An identifier for the category
		public let id: String
		
		/// The translation key for the heading of a category
		public let heading: String
		
		/// The translation key for the sub heading of a category
		public let subheading: String
		
		/// An array of sub categories holding the accepted HCIMs
		public let subcategories: [SubCategory]
		
		/// Create a category
		/// - Parameters:
		///   - id: An identifier for the category
		///   - heading: The translation key for the heading of a category
		///   - subheading: The translation key for the sub heading of a category
		///   - subcategories: An array of sub categories holding the accepted HCIMs
		public init(
			id: String,
			heading: String,
			subheading: String,
			subcategories: [SubCategory],
		) {
			self.id = id
			self.heading = heading
			self.subheading = subheading
			self.subcategories = subcategories
		}
		
		/// Get all the profiles from the sub categories
		/// - Returns: an array of profiles
		public func profiles() -> [String] {
			subcategories.flatMap(\.profiles)
		}
		
		/// Get the localized string for the heading
		/// - Returns: localized string for the heading
		public func localizedHeading() -> String {
			return String(localized: String.LocalizationValue(stringLiteral: heading))
		}
		
		/// Get the localized string for the sub heading
		/// - Returns: localized string for the sub heading
		public func localizedSubheading() -> String {
			return String(localized: String.LocalizationValue(stringLiteral: subheading))
		}
	}

	// MARK: - Main Category
	
	/// the Health Categories Error
	public enum Error: Swift.Error, Sendable {
		
		/// No resource file found
		case noResource
	}
	
	/// A main category is a container of categories. i.e. health, research, care or administration
	public struct MainCategory: Codable, Equatable, Identifiable, Hashable, Sendable {
		
		/// The Identifier
		public let id: String
		
		/// The translation key for the heading
		public let heading: String
		
		/// An array of categories for this main category
		public let categories: [Category]
		
		/// Create a Main Category
		/// - Parameters:
		///   - id: the identifier
		///   - heading: the key for the heading
		///   - categories: the categories for this main category
		public init(id: String, heading: String, categories: [Category]) {
			self.id = id
			self.heading = heading
			self.categories = categories
		}
		
		/// Get the localized string for the heading
		/// - Returns: localized string for the heading
		public func localized() -> String {
			return String(localized: String.LocalizationValue(stringLiteral: heading))
		}
	}
	
	/// An array of main categories
	public let mainCategories: [MainCategory]
	
	/// An array of all the categories
	/// - Returns: all the categories
	public func categories() -> [Category] {
		mainCategories.flatMap(\.categories)
	}
	
	/// Create the health categories. load the resources
	public init() throws {
		
		guard let resourcePath = Bundle.main.path(forResource: "shared-health-categories", ofType: "json") else {
			logError("SharedHealthCategories.Error: No resources found")
			throw SharedHealthCategories.Error.noResource
		}
		let data = try Data(contentsOf: URL(fileURLWithPath: resourcePath))
		do {
			self.mainCategories = try JSONDecoder().decode([MainCategory].self, from: data)
		} catch {
			logError("error", error)
			throw error
		}
	}
	
	/// Find a category by its id
	/// - Parameter id: the identifier of the category
	/// - Returns: optional category
	public func findCategory(id: String) -> Category? {
		for mainCategory in mainCategories {
			for category in mainCategory.categories where category.id == id {
				
				return category
			}
		}
		return nil
	}
}
