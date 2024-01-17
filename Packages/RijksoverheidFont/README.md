# RijksoverheidFont

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

## License

License is released under the EUPL 1.2 license. [See LICENSE](./LICENSE.txt) for details.
