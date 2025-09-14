/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import MGOUI

class PatientFriendlyTermViewModel: ObservableObject {
	
	var onClose: (() -> Void)?
	
	/// The title of a patient friendly term
	@Published var title: String?
	
	/// The synonym of a patient friendly term
	@Published var synonym: String?
	
	/// The description of a patient friendly term
	@Published var description: String
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case closeSheet
	}
	
	/// Create a Healthcare Data View Model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter term: the patient friendly term
	@MainActor init(
		onClose: (() -> Void)? = nil,
		term: PatientFriendlyTerm
	) {
		self.onClose = onClose
		self.description = Sanitizer.sanitize(term.description)
		self.synonym = Sanitizer.strip(term.synonym)
		self.title = Sanitizer.strip(term.name)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: PatientFriendlyTermViewModel.Action) {
		
		if action == .closeSheet {
			onClose?()
		}
	}
}

struct PatientFriendlyTermView: View {
	
	/// The View Model
	@StateObject var viewModel: PatientFriendlyTermViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 16
		}
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 12
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.spacing) {
				
				HStack(alignment: .top, spacing: 0) {
					if let title = viewModel.title {
						Text(title)
							.rijksoverheidStyle(font: .bold, style: .headline)
							.foregroundStyle(theme.contentPrimary)
							.frame(maxWidth: .infinity, alignment: .leading)
							.accessibilityAddTraits(.isHeader)
					}
					Spacer()
					
					CloseButton({
						viewModel.reduce(.closeSheet)
					})
					.buttonStyle(CloseButtonStyle())
				}
				
				if let synonym = viewModel.synonym {
					Text(
						String(
							format: String(localized: "patientfriendlyterms.synonym"),
							arguments: [synonym]
						)
					)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentSecondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				SelectableTextView(
					text: viewModel.description,
					textColor: theme.contentPrimary,
					font: UIFont(
						name: RijksoverheidSansWebTextFont.regular.fontName,
						size: Font.TextStyle.body.pointSize
					)
				)
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.Navigation.padding)
		}
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.when(isPresentedAsSheet, transform: { view in
			view
				.backport.presentationDetents([.medium])
		})
	}
}

#Preview {
	NavigationView {
		PatientFriendlyTermView(
			viewModel: PatientFriendlyTermViewModel(
				onClose: nil,
				term: PatientFriendlyTerm(
					name: "Patient Vriendelijke Term",
					description: "Een langere omschrijving van een paar regels wat deze term inhoud.",
					synonym: "synonym"
				)
			)
		)
	}
}
