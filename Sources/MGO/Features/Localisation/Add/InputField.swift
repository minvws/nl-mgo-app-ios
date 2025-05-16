/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Is this a required field?
	var required: Bool = false
	
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
			static let width: CGFloat = 17
			static let height: CGFloat = 18
		}
		enum Input {
			static let cornerRadius: CGFloat = 10
			static let inset: CGFloat = 0.5
			static let horizontalPadding: CGFloat = 12
			static let verticalPadding: CGFloat = 12
		}
		enum Button {
			static let trailing: CGFloat = 12
		}
		enum VStack {
			static let spacing: CGFloat = 8
		}
	}
	
	/// Helper to change the border color when the textfield is focused.
	@FocusState var isFieldFocused: Bool
	
	var body: some View {
		
		VStack(spacing: ViewTraits.VStack.spacing) {
			
			Text(title)
				.when(required, transform: { text in
					text + Text(verbatim: " ") + Text("common.required")
				})
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.onTapGesture {
					isFieldFocused.toggle()
				}
			
			TextField("", text: $input)
				.focused($isFieldFocused)
				.padding(.horizontal, ViewTraits.Input.horizontalPadding)
				.padding(.vertical, ViewTraits.Input.verticalPadding)
				.foregroundStyle(theme.contentPrimary)
				.accentColor(theme.interactionTertiaryDefaultText)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(theme.backgroundSecondary)
				.cornerRadius(ViewTraits.Input.cornerRadius)
				.accessibilityIdentifier("input")
				.overlay(
					RoundedRectangle(cornerRadius: ViewTraits.Input.cornerRadius)
						.inset(by: ViewTraits.Input.inset)
						.stroke(getBorderColor(), lineWidth: isFieldFocused || showError ? 2 : 0)
				)
				.overlay(alignment: .trailing) {
					Button(
						action: {
							input = ""
						},
						label: {
							Image(ImageResource.Localisation.clear)
						}
					)
					.buttonStyle(IconButtonStyle())
					.accessibilityLabel("common.clear")
					.accessibilityHidden(!isFieldFocused)
					.padding(.trailing, ViewTraits.Button.trailing)
					.opacity(isFieldFocused && input.isNotEmpty ? 1 : 0)
				}
				
			if showError {
				HStack(alignment: .center, spacing: ViewTraits.Image.spacing) {
					Image(ImageResource.Localisation.error)
						.resizable()
						.frame(width: ViewTraits.Image.width, height: ViewTraits.Image.height)
					
					Text(errorMessage)
						.rijksoverheidStyle(font: .bold, style: .body)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.foregroundStyle(theme.sentimentCritical)
				}
				.onTapGesture {
					isFieldFocused.toggle()
				}
				.accessibilityElement(children: .combine)
			}
		}
	}
	
	private func getBorderColor() -> Color {
		
		guard !showError else {
			return theme.sentimentCritical
		}
		return isFieldFocused ? theme.interactionPrimaryDefaultText : theme.borderPrimary
	}
}

#Preview {
	
	return VStack {
		
		InputField(
			input: .constant("correct"),
			errorMessage: .constant(""),
			title: "Title",
			required: false
		)
		.padding(16)
		
		InputField(
			input: .constant("wrong"),
			errorMessage: .constant("error message"),
			title: "Title",
			required: true
		)
		.padding(16)
	}
	.background(Theme().backgroundPrimary)
}
