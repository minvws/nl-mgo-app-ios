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

### Button

The main call to action button is available in three flavors:

```swift
import ReusebleUI 
struct ButtonView: View {	
	var body: some View {
			VStack {
				CallToActionButton("onboarding_action", style: .primary)
					.padding(16)
				CallToActionButton("onboarding_action", style: .secondary)
					.padding(16)
				CallToActionButton("onboarding_action", style: .destructive)
					.padding(16)
			}
		}
	}
}
```

<img style="float: left;" src="illustrations/CallToAction.png" />

### Card

### Circular Progress View

### Haptic Feedback

### Toast

A simple view to diplay feedback to the user. 

```swift
import ReuseableUI

class ContentViewModel: ObservableObject {

  /// A list of all the actions this viewModel can handle
	enum Action {
		case closeToast
	}
	
	/// Any toast to display?
	@Published var toast: Toast?
	
	/// Intitializer
	/// - Parameter showToast: should we show a toast
	init(showToast: Bool = false) {
		if showToast {
			toast = Toast(
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
			case .closeToast:
				toast = nil
		}
	}
}

struct ContentView: View {
	
	/// The view model
	@StateObject var viewModel: ContentViewModel
				
	if let toast = viewModel.toast {
			
		ToastView(toast) {
			// User pressed on the close button
			withAnimation {
				viewModel.reduce(.closeToast)
			}
		}
	}
	...
}
```






<img style="float: left;" src="illustrations/Toast.png" />


### ConditionalViewModifier

You can not aways use an **if** statement in a view, hence the conditionalViewModifier. 
*Note that there is no **else** option.* 

```swift
Text("ConditionalViewModifier")
		.if(state == .warning, transform: { view in
			view.foregroundStyle(.orange)
		})
```



### DetailRow

### SplittedText





## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/LICENSE.txt) for details.
