/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct ImageContentView: View {
	
	public enum Alignment {
		case leading
		case center
	}
	
	/// The order of the elements
	public enum Order {
		case imageFirst
		case contentFirst
	}
	
	/// The layout configuration
	public struct Configuration {
		
		// the alignment of the texts
		var textAlignment: ImageContentView.Alignment
		
		// the spacing between the texts
		var textSpacing: CGFloat
		
		// the style of the title
		var titleStyle: Typography
		
		// the color of the sub heading
		var subHeadingForegroundColor: Color
		
		// the order of the content and image
		var order: ImageContentView.Order
		
		// The maximum width the icon can use
		var maxWidthPercentage: Double
		
		/// Should we hide the icon on rotation to landscape?
		var hideIconInLandscape: Bool
		
		/// Do we use the heading as a navigation title?
		var headingAsNavigationTitle: Bool
		
		/// Create a view with image and text
		/// - Parameters:
		///   - textAlignment: the alignment of the texts
		///   - textSpacing: the spacing between the texts
		///   - titleStyle: the style of the title
		///   - subHeadingForegroundColor: the color of the sub heading
		///   - order: the order of the content and image
		///   - maxWidthPercentage: The maximum width the icon can use (1 = 100% full width)
		///   - hideIconInLandscape: Should we hide the icon on rotation to landscape?
		public init(
			textAlignment: ImageContentView.Alignment = .center,
			textSpacing: CGFloat = 8,
			titleStyle: Typography = .headingSmall,
			subHeadingForegroundColor: Color,
			order: ImageContentView.Order = .imageFirst,
			maxWidthPercentage: Double = 0.5,
			hideIconInLandscape: Bool = true,
			headingAsNavigationTitle: Bool = false
		) {
			self.textAlignment = textAlignment
			self.textSpacing = textSpacing
			self.titleStyle = titleStyle
			self.subHeadingForegroundColor = subHeadingForegroundColor
			self.order = order
			self.maxWidthPercentage = maxWidthPercentage
			self.hideIconInLandscape = hideIconInLandscape
			self.headingAsNavigationTitle = headingAsNavigationTitle
		}
	}
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The size classes
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Create an empty view for a list
	/// - Parameters:
	///   - icon: the icon to be displayed
	///   - heading: the heading of the empty state
	///   - subHeading: the sub heading of the empty state
	///   - configuration: The layout configuration
	public init(
		icon: Image,
		heading: LocalizedStringKey,
		subHeading: LocalizedStringKey,
		configuration: ImageContentView.Configuration
	) {
		self.icon = icon
		self.heading = heading
		self.subHeading = subHeading
		self.configuration = configuration
	}
	
	/// The icon to be displayed
	public var icon: Image
	
	/// The language key for the heading
	public var heading: LocalizedStringKey
	
	/// The language key for the sub heading
	public var subHeading: LocalizedStringKey
	
	/// The layout configuration
	private var configuration: ImageContentView.Configuration
	
	/// helper to calculate the size of the view
	@State private var contentSize: CGSize = .zero
	
	/// Boolean to determine if the header image should be shown (hidden in landscape)
	@State var showImage = true
	
	/// Magic Numbers
	private struct ViewTraits {
		enum View {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 8
			static let top: CGFloat = 12
		}
	}

	@ViewBuilder
	private var contentStack: some View {
		VStack(alignment: configuration.textAlignment == .center ? .center : .leading, spacing: configuration.textSpacing) {
			if !configuration.headingAsNavigationTitle {
				Text(heading)
					.typography(configuration.titleStyle)
					.foregroundColor(theme.labels.primary)
					.multilineTextAlignment(configuration.textAlignment == .center ? .center : .leading)
					.fixedSize(horizontal: false, vertical: true)
					.accessibilityIdentifier("imagecontentview.heading")
					.accessibilityAddTraits(.isHeader)
			}
			Text(subHeading)
				.typography(.bodyMedium)
				.foregroundColor(configuration.subHeadingForegroundColor)
				.multilineTextAlignment(configuration.textAlignment == .center ? .center : .leading)
				.fixedSize(horizontal: false, vertical: true)
				.accessibilityIdentifier("imagecontentview.subheading")
			
			Spacer()
		}
		.frame(maxWidth: .infinity,
			   alignment: configuration.textAlignment == .center ? .center : .leading
		)
	}
	
	@ViewBuilder
	private var imageStack: some View {
		// Image, 50% width
		VStack(alignment: .center) {
			Spacer()
			
			icon
				.resizable()
				.aspectRatio(contentMode: .fill)
				.padding(.bottom, ViewTraits.View.padding)
		}
		.frame(maxWidth: contentSize.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.33 : configuration.maxWidthPercentage)
		)
	}
	
	public var body: some View {
			
		VStack(alignment: .center) {
			
			switch configuration.order {
				case .imageFirst:
					if showImage {
						imageStack
					}
					contentStack
					
				case .contentFirst:
					contentStack
					if showImage {
						imageStack
					}
			}
		}
		.readSize($contentSize)
		.accessibilityElement(children: .combine)
		.padding(.top, ViewTraits.View.top)
		.onRotate { newOrientation in
			handleRotation(newOrientation)
		}
		.onAppear {
			
			guard configuration.hideIconInLandscape else { return }
			
			showImage = verticalSizeClass != SwiftUI.UserInterfaceSizeClass.compact || UIDevice.current.userInterfaceIdiom == .pad
		}
		.when(configuration.headingAsNavigationTitle) { view in
			view
				.navigationTitle(heading)
		}
	}
	
	/// Handle Rotation
	/// - Parameter newOrientation: the new orientation
	func handleRotation(_ newOrientation: UIDeviceOrientation) {
		
		// Always show on iPad
		guard UIDevice.current.userInterfaceIdiom != .pad else { return }
		
		// The device orientation can be isFlat (faceUp or faceDown). Skip that
		guard !newOrientation.isFlat else { return }
		
		// Obey config setting
		guard configuration.hideIconInLandscape else { return }
		
		// Hide the image in landscape (on a phone)
		showImage = !newOrientation.isLandscape
	}
}

#Preview {
	ImageContentView(
		icon: Image(systemName: "42.circle"),
		heading: "Heading",
		subHeading: "SubHeading",
		configuration: ImageContentView
			.Configuration(
				textAlignment: .center,
				textSpacing: 8,
				titleStyle: .headingExtraLarge,
				subHeadingForegroundColor: Color.orange,
				order: .imageFirst
			)
		)
}
