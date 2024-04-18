/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct InputField: View {
	
	/// The binding input
	@Binding var input: String
	
	/// The binding error message
	@Binding var errorMessage: LocalizedStringKey
	
	/// The title for this view
	var title: LocalizedStringKey
	
	/// Helper to decide if we should show the error state
	private var showError: Bool {
		return errorMessage != ""
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let spacing: CGFloat = 8
			static let size: CGFloat = 17
		}
		enum Input {
			static let cornerRadius: CGFloat = 8
			static let inset: CGFloat = 0.5
			static let horizontalPadding: CGFloat = 12
			static let verticalPadding: CGFloat = 8
		}
		enum VStack {
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		VStack(spacing: ViewTraits.VStack.spacing) {
			
			Text(title)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
			
			TextField("", text: $input)
				.padding(.horizontal, ViewTraits.Input.horizontalPadding)
				.padding(.vertical, ViewTraits.Input.verticalPadding)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(theme.backgroundSecondary)
				.cornerRadius(ViewTraits.Input.cornerRadius)
				.overlay(
					RoundedRectangle(cornerRadius: ViewTraits.Input.cornerRadius)
						.inset(by: ViewTraits.Input.inset)
						.stroke(showError ? theme.notificationError : theme.contentPrimary, lineWidth: 1)
				)
			if showError {
				HStack(alignment: .center, spacing: ViewTraits.Image.spacing) {
					Image(ImageResource.Search.error)
						.resizable()
						.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
					
					Text(errorMessage)
						.rijksoverheidStyle(font: .bold, style: .body)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.foregroundStyle(theme.notificationError)
				}
				.accessibilityElement(children: .combine)
			}
		}
	}
}

#Preview {
	VStack {
		
		InputField(
			input: .constant("correct"),
			errorMessage: .constant(""),
			title: "Title"
		)
		.padding(16)
		
		InputField(
			input: .constant("wrong"),
			errorMessage: .constant("error message"),
			title: "Title"
		)
		.padding(16)
	}
}
