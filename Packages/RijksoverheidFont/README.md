# RijksoverheidFont

## Overview

A helper module to use the Rijksoverheid sans Web Text fonts in SwiftUI

## Usage

To display a Text with the Rijksoverheid styling, use the `.typography` modifier

```swift
Text("Rijksoverheid")
    .typography(.headingLarge)
```

There are 5 levels of heading, and 3 for body texts:

```swift
public enum Typography: CaseIterable {

    case headingExtraLarge  // 34 pt (.largeTitle)
    case headingLarge       // 28 pt (.title)
    case headingMedium      // 22 pt (.title2)
    case headingSmall       // 20 pt (.title3)
    case headingExtraSmall  // 18 pt (.subheadline)

    case bodyLarge          // 20 pt (.headline)
    case bodyMedium         // 18 pt (.body)
    case bodySmall          // 16 pt (.callout)
}
```

The modifier accepts an optional `with` parameter to override the default font variant. Heading styles default to `.bold`; body styles default to `.regular`.

```swift
// Default weight for the style (bold heading, regular body)
Text("Rijksoverheid")
    .typography(.bodyMedium)

// Override with a different variant
Text("Rijksoverheid")
    .typography(.bodyMedium, with: .semiBold)

Text("Toelichting")
    .typography(.bodySmall, with: .italic)
```

You can also use the font directly without the typography modifier:

```swift
Text("Rijksoverheid")
    .font(
        .RijksoverheidSansWebText.relative(
            .regular,
            relativeTo: .title
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

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.
This does NOT apply to the fonts in the Sources/RijksoverheidFont/Resources folder. Those are properietary assets to the Dutch Ministry of General Affairs.  
