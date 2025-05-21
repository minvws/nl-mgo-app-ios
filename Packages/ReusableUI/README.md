# Reuseable UI

## Overview

This package holds a small collection of reuseable visual elements

## Usage

### Accordion

A classic accordion, to expand or collapse a detail view

```swift
import ReusebleUI 
struct DetailView: View {	
	var body: some View {
		VStack {
			AccordionView("First section", startOpen: true) {
			  Text("Details First Section. Starts expanded.")
			  ...
			}
		  
			AccordionView("Second section") {
			  Text("Details Second Section. Starts collapsed.")
				...
		  }
		}
	}
}
```

<img style="float: left;" src="illustrations/Accordion.png" />

### BlurView

A helper for using the UIKit UIBlurEffect in SwiftUI

```swift
import ReusebleUI 

Text("BlurEffect")
	.background(BlurView(style: .systemUltraThinMaterial))

```

### Button

The main call to action button is available in nine flavors:

```swift
import ReusebleUI 
struct ButtonView: View {	
	var body: some View {
		VStack {
			CallToActionButton(".digiD", icon: Image(systemName: "stethoscope"), style: .loginWithDigiD)
				.padding(16)
			CallToActionButton(".primary", style: .primary)
				.padding(16)
			CallToActionButton(".primaryCritical", style: .primaryCritical)
				.padding(16)
			CallToActionButton(".secondary", style: .secondary)
				.padding(16)
			CallToActionButton(".secondaryCritical", style: .secondaryCritical)
				.padding(16)
			CallToActionButton(".tertiary", style: .tertiary)
				.padding(16)
			CallToActionButton(".tertiaryCritical", style: .tertiaryCritical)
				.padding(16)
			CallToActionButton(".withIcon", icon: Image(systemName: "stethoscope"), style: .withIcon)
				.padding(16)
			CallToActionButton(".withSpinner", style: .withSpinner)
				.padding(16)
		}
	}
}
```

<img style="float: left;" src="illustrations/CallToAction.png" />

### Card

One common element in the UI is to make a view look like a card. The `.cardify()` modifier makes any view look like a card. 

A much used loader has its own LoadingCardView with a title:

<img style="float: left;" src="illustrations/LoadingCard.png" />

For errors and and other feedback, we have a NotificationCard with an image, title and message. 

<img style="float: left;" src="illustrations/NotificationCard.png" />

You can apply it to any view, Here is an example of a button:

<img style="float: left;" src="illustrations/Login.png" />

### Circular Progress View

To draw a circular progress view, you call 

```swift
	CircularProgressView(progress: 0.25, lineWidth: 6)
		.frame(width: 50, height: 50)
```

Which draws something like

<img style="float: left;" src="illustrations/CircularProgress.png" />

### Haptic Feedback

Whenever you want to give some haptic feedback to the user, you can use `Haptic.light()`, `Haptic.medium()` or `Haptic.heavy()`

There is a viewModifier variant, `Text("Press me").hapticFeedback(HapticFeedback.medium)`

### Feedback Banner

A simple view to diplay feedback to the user. 

```swift
import ReuseableUI

class ContentViewModel: ObservableObject {

  /// A list of all the actions this viewModel can handle
	enum Action {
		case closeBanner
	}
	
	/// Any banner to display?
	@Published var banner: Banner?
	
	/// Intitializer
	/// - Parameter showBanner: should we show a banner
	init(showBanner: Bool = false) {
		if showBanner {
			banner = Banner(
				title: String(localized: "title"),
				subtitle: String(localized: "subtitle"),
				type: .success
			)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: ContentViewModel.Action) {
		switch action {
			case .closeBanner:
				banner = nil
		}
	}
}

struct ContentView: View {
	
	/// The view model
	@StateObject var viewModel: ContentViewModel
	...
  var body: some View {
	  if let banner = viewModel.banner {
			
		  BannerView(banner) {
			 // User pressed on the close button
			  withAnimation {
				  viewModel.reduce(.closeBanner)
			 }
		 }
	 }
    ...
 }
}
```

There are four different types of Banner: **.info**, **.warning**, **.error** and **.success**

<img style="float: left;" src="illustrations/Banner.png" />

### Feedback Toast

Another way to display feedback to the user is through a toast. 

```swift

VStack {
	ToastView(Feedback(title: "Title", subtitle: "Text", type: .info))
	ToastView(Feedback(title: "Title", subtitle: "Text", type: .warning))
	ToastView(Feedback(title: "Title", subtitle: "Text", type: .error))
	ToastView(Feedback(title: "Title", subtitle: "Text", type: .success)) {
		// Action when underlined Text is clicked
	}
}
```

There are four different types of Toast: **.info**, **.warning**, **.error** and **.success**

<img style="float: left;" src="illustrations/Toast.png" />

### ConditionalViewModifier

You can not aways use an **if** statement in a view, especially when using view modifiers, hence the conditionalViewModifier. 
*Note that there is no **else** option.* 

```swift
Text("ConditionalViewModifier")
		.when(state == .warning, transform: { view in
			view.foregroundStyle(.orange)
		})
```

### DetailRow

A simple view to display details, containing a title and a body

```swift
DetailRow(title: "The Title", content: "The Content") .padding(16).border(Color.black).padding(16)
```

<img style="float: left;" src="illustrations/DetailRow.png" />

### SplittedText

Large bodies of text are read by Voice Over as one continuous block. There is the SplittedText view that breaks that down to a list of indivudual Text elements, that are read one by one by Voice Over.

Params are the spacing between the rows, and the alignment of the Text. 

```swift
VStack {
		SplittedText("Content\nContent\nMore Content", spacing: 8, alignment: .center)
				.padding(.bottom, 16)
		
		SplittedText("Content\nContent\nMore Content", spacing: 3, alignment: .leading)
}
```

<img style="float: left;" src="illustrations/SplittedText.png" />

### ImageContentView

A reoccurring view in our project is a large image with content underneath.

```swift
	ImageContentView(
		icon: Image(systemName: "42.circle"),
		heading: "Heading",
		subHeading: "SubHeading",
		textAlignment: .center,
		textSpacing: 8,
		titleStyle: .largeTitle,
		subHeadingForegroundColor: Color.pink
	)

``` 

<img style="float: left;" src="illustrations/ImageContent.png" />

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/ReusableUI/LICENSE.txt) for details.
