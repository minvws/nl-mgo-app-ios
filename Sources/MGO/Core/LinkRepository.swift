/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation

public struct LinkRepository {
	
	/// the URL for the privacy page
	public static var privacyURL: URL? {
		
		switch Configuration().getRelease() {
			case .production:
				return URL(string: String(localized: "privacy.link.prod"))
			case .demo, .acceptance:
				return URL(string: String(localized: "privacy.link.acc"))
			case .test, .development:
				return URL(string: String(localized: "privacy.link.test"))
		}
	}
}
