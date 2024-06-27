/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct OverviewCardView: View {
	
	/// The model of the healthcare organization
	var model: OverviewHealthcareOrganization
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	var body: some View {
		
		ActionCardView(
			title: LocalizedStringKey(stringLiteral: model.name),
			message: LocalizedStringKey(stringLiteral: model.category),
			icon: .none,
			perform: perform
		)
	}
}

#Preview {
	VStack(spacing: 4) {
		OverviewCardView(model: OverviewHealthcareOrganization(category: "Tandartsen", id: "1", name: "Tandarts Tandje Erbij"))
		OverviewCardView(model: OverviewHealthcareOrganization(category: "Tandartsen", id: "2", name: "Tandarts Tandje Erbij"))
		OverviewCardView(model: OverviewHealthcareOrganization(category: "Tandartsen", id: "3", name: "Tandarts Tandje Erbij"))
	}
}
