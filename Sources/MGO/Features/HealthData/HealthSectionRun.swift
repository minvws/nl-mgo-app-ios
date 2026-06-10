/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

/// A contiguous run of UI elements within a schema group, classified by layout:
/// normal elements collapse into a single card, while a full-width element
/// (e.g. an edge-to-edge image) breaks out on its own.
enum HealthSectionRun {

	case card([UIElementProtocol])
	case fullWidth(UIElementProtocol)

	/// Splits a group's elements into contiguous runs. Consecutive non-full-width
	/// elements collapse into one `.card`; each full-width element becomes its own
	/// `.fullWidth`, flushing any card in progress.
	static func runs(from elements: [UIElementProtocol]) -> [HealthSectionRun] {
		var runs: [HealthSectionRun] = []
		var currentCard: [UIElementProtocol] = []

		func flushCard() {
			guard !currentCard.isEmpty else { return }
			runs.append(.card(currentCard))
			currentCard = []
		}

		for element in elements {
			if element.prefersFullWidth {
				flushCard()
				runs.append(.fullWidth(element))
			} else {
				currentCard.append(element)
			}
		}
		flushCard()
		return runs
	}
}
