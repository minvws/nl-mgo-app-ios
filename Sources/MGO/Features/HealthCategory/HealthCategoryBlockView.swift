/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthCategoryBlockView: View {
	
	let block: HealthCategoryBlock
	let blockIndex: Int
	let isLast: Bool
	let useTimeline: Bool
	let showHeading: Bool
	
	@Environment(\.mgoTheme) var theme
	
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let spacing: CGFloat = 8
		}
		enum TimeLine {
			static let width: CGFloat = 16
			static let lineWidth: CGFloat = 2
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		let isUnknown = block.isUnknownDate
		let showLineAbove = useTimeline && !isUnknown && blockIndex != 0
		let showLineBelow = useTimeline && !isUnknown && !isLast
		
		if showHeading {
			blockHeader(
				isUnknown: isUnknown,
				showLineAbove: showLineAbove,
				showLineBelow: showLineBelow
			)
		}
		
		ForEach(Array(block.rows.enumerated()), id: \.offset) { index, element in
			
			HStack(spacing: ViewTraits.TimeLine.spacing) {
				
				if useTimeline && !isUnknown {
					rowTimeline(visible: showLineBelow)
				}
				
				HealthCategoryBlockRowView(
					element: element,
					accessibilityIdentifier: "category_element_\(blockIndex)_\(index)"
				)
				.padding(.top, ViewTraits.List.spacing)
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
	}
	
	/// Vertical line for non-header rows. Renders `Color.clear` at the same width when hidden so row content stays aligned.
	@ViewBuilder private func rowTimeline(visible: Bool) -> some View {
		
		if visible {
			Rectangle()
				.fill(theme.separators.timeline)
				.frame(width: ViewTraits.TimeLine.lineWidth)
				.frame(width: ViewTraits.TimeLine.width)
		} else {
			Color.clear.frame(width: ViewTraits.TimeLine.width)
		}
	}
	
	/// Timeline column for the header row. Mirrors the heading text's top/bottom padding on the circle so it stays
	/// vertically centred on the heading under `HStack(.center)`.
	/// - Parameters:
	///   - showLineAbove: draw the segment above the circle.
	///   - showLineBelow: draw the segment below the circle.
	///   - circleColor: fill colour for the dot.
	@ViewBuilder private func headerTimeline(
		showLineAbove: Bool,
		showLineBelow: Bool,
		circleColor: Color
	) -> some View {
		
		let topPadding: CGFloat = blockIndex == 0 ? 8 : 24
		
		ZStack {
			headerTimelineSegments(
				topPadding: topPadding,
				showLineAbove: showLineAbove,
				showLineBelow: showLineBelow
			)
			
			Circle()
				.fill(circleColor)
				.frame(
					width: ViewTraits.TimeLine.width,
					height: ViewTraits.TimeLine.width
				)
				.padding(.top, topPadding)
				.padding(.bottom, 2)
		}
		.frame(width: ViewTraits.TimeLine.width)
	}
	
	/// Returns the heading text colour: secondary for unknown-date blocks, `rijkslint` for dated timeline blocks, primary otherwise.
	private func headingColor(isUnknown: Bool) -> Color {
		
		if isUnknown { return theme.labels.secondary }
		if useTimeline { return theme.categories.rijkslint }
		return theme.labels.primary
	}
	
	/// Two `Rectangle` segments stacked above and below the circle dot. The split sits at the circle's vertical centre
	/// (`topPadding + circleRadius`) so the upper segment always meets the dot — a 50/50 split lands at the ZStack
	/// centre, which is 11pt above the circle because of its 24/2 asymmetric padding. Each segment is `Color.clear`
	/// when its flag is `false`, preserving the layout geometry so the circle position stays stable.
	/// - Parameters:
	///   - topPadding: top padding applied to the circle in `headerTimeline` — used to align the segment split.
	///   - showLineAbove: colour the top segment with the timeline separator colour.
	///   - showLineBelow: colour the bottom segment with the timeline separator colour.
	@ViewBuilder private func headerTimelineSegments(
		topPadding: CGFloat,
		showLineAbove: Bool,
		showLineBelow: Bool
	) -> some View {
		
		VStack(spacing: 0) {
			Rectangle()
				.fill(showLineAbove ? theme.separators.timeline : Color.clear)
				.frame(height: topPadding + ViewTraits.TimeLine.width / 2)
			Rectangle()
				.fill(showLineBelow ? theme.separators.timeline : Color.clear)
		}
		.frame(width: ViewTraits.TimeLine.lineWidth)
	}
	
	/// The heading row for a `HealthCategoryBlock`.
	///
	/// In `.regular` mode this is just the block's title. In `.timeline` mode
	/// it is preceded by the timeline column (`headerTimeline`) — a vertical
	/// line with a circle whose top/bottom segments are toggled per block:
	/// the first block hides the segment above, the last dated block hides
	/// the segment below, and the trailing "unknown date" block opts out of
	/// the column entirely and renders in `theme.labels.secondary`.
	@ViewBuilder private func blockHeader(
		isUnknown: Bool,
		showLineAbove: Bool,
		showLineBelow: Bool
	) -> some View {
		
		HStack(alignment: .center, spacing: ViewTraits.TimeLine.spacing) {
			
			if useTimeline {
				headerTimeline(
					showLineAbove: showLineAbove,
					showLineBelow: showLineBelow,
					circleColor: isUnknown ? theme.labels.secondary : theme.categories.rijkslint
				)
			}
			
			Text(block.heading)
				.typography(
					useTimeline ? .bodyMedium : .headingMedium,
					with: .bold
				)
				.foregroundColor(headingColor(isUnknown: isUnknown))
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.padding(.leading, useTimeline ? 0 : ViewTraits.General.padding)
				.padding(.top, blockIndex == 0 ? 8 : 24)
				.padding(.bottom, 2)
		}
		.padding(.horizontal, ViewTraits.General.padding)
	}
}
