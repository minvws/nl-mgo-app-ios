# RijksoverheidFont

## Overview

A helper module to use the Rijksoverheid sans Web Text fonts in SwiftUI

## Usage

To display a Text with the Rijksoverheid styling, use the `.rijksoverheidStyle` modifier

```swift
Text("Rijksoverheid")
    .rijksoverheidStyle(font: .bold, style: .largeTitle)
```

The modifier takes two params, font and style. Three fonts are supplied: `.bold`, `.italic` and `.regular`. The style is one of the [Font.TextStyle](https://developer.apple.com/documentation/swiftui/font/textstyle) enum values, `.largeTitle`, `.title`, `.body` etc.

These fonts will scale relative to the user preference for display size. If you need a fixed size, use

```swift
Text("Rijksoverheid")
    .font(.RijksoverheidSansWebText.fixed(.regular, size: 17))
```

The first param is the font to be used, the second is the CGFloat point size. 

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/RijksoverheidFont/LICENSE.txt) for details.
This does NOT apply to the fonts in the Sources/RijksoverheidFont/Resources folder. Those are properietary assets to the Dutch Ministry of General Affairs.  
