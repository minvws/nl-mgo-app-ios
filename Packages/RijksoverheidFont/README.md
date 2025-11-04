# RijksoverheidFont

## Overview

A helper module to use the Rijksoverheid sans Web Text fonts in SwiftUI

## Usage

To display a Text with the Rijksoverheid styling, use the `.typography` modifier

```swift
Text("Rijksoverheid")
    .typography(.headingLarge)
```

There are 5 levels of heading, and 3 for body texts. :

```swift
public enum Typography: CaseIterable {
	
	case headingExtraLarge // 34 px (.largeTitle)
	case headingLarge // 28 px (.title)
	case headingMedium // 22 px (.title2)
	case headingSmall // 20 px (.title3)
	case headingExtraSmall // 18 px (.subheadline)

	case bodyLarge // 20 px (.headline)
	case bodyMedium // 18 px (.body)
	case bodySmall // 16 px (.callout)
}
```

The modifier takes two params, Typography and isBold.

```swift
Text("Rijksoverheid")
    .font(.bodyMedium, isBold: true)
```
Note that the heading styles are always bold. You can use any of the Font.TextStyles directly without the typography modifier:

```swift
Text("Rijksoverheid")
.font(
	.RijksoverheidSansWebText.relative(
		RijksoverheidSansWebTextFont.regular,
		relativeTo: Font.TextStyle.title
	)
)
```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios-private?tab=License-1-ov-file#readme) for details.
This does NOT apply to the fonts in the Sources/RijksoverheidFont/Resources folder. Those are properietary assets to the Dutch Ministry of General Affairs.  
