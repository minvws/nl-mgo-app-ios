/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct HealthCategoryRowView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The category to display
	var block: CategoryButton
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Block {
			static let spacing: CGFloat = 16
			static let minHeight: CGFloat = 56
		}
		enum Icon {
			static let size: CGFloat = 24
		}
		enum Spinner {
			static let lineWidth: CGFloat = 3
			static let size: CGFloat = 22
		}
	}
	
	var body: some View {
		
		HStack(spacing: ViewTraits.Block.spacing) {
			
			block.getIcon(theme)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
			
			Text(block.title)
			.foregroundStyle(theme.contentPrimary)
			
			Spacer()
			
			Group {
				switch block.state {
					case .empty, .notAvailabe:
						Text("common.no_data")
					case .loaded:
						Image(systemName: "chevron.right")
							.font(.body)
							.foregroundStyle(theme.symbolSecondary)
					case .loading:
						HStack {
							Text("common.loading_data")
						
							ProgressView()
								.progressViewStyle(.circular)
								.frame(width: ViewTraits.Spinner.size, height: ViewTraits.Spinner.size)
								.tint(theme.symbolSecondary)
						}
				}
			}
			.foregroundStyle(theme.contentSecondary)
		}
		.rijksoverheidStyle(font: .regular, style: .body)
		.padding(ViewTraits.Block.spacing)
		.frame(minHeight: ViewTraits.Block.minHeight)
		.accessibilityElement(children: .combine)
	}
}

#Preview {
	VStack {
		HealthCategoryRowView(block: CategoryButton(category: .medication, title: "Medicijnen"))
		HealthCategoryRowView(block: CategoryButton(category: .measurements, title: "Metingen", state: .loaded, box: 1))
		HealthCategoryRowView(block: CategoryButton(category: .complaints, title: "Klachten", state: .empty, box: 2))
		HealthCategoryRowView(block: CategoryButton(category: .payment, title: "Betaalgegevens", state: .notAvailabe, box: 3))
	}
	.background(Theme().backgroundPrimary)
}
