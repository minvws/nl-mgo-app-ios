/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// The flavours of the app
public enum Release: String {
	case production
	case acceptance = "acc"
	case demo
	case test
	case development = "dev"
}
