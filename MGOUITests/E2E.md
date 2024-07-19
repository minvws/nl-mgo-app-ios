#  End to end Tests

## Launch Options

- `-resetOnStart` will clear any existing data and create a first visit experience
- `-disableTransitions` will speedup animation and navigation
- `-updateRequired` will force the update required flow by mocking the remote configuration
- `-skipOnboarding` will skip the appIntroduction and privacy statement
- `-pincode:xxxxx` will set the pincode to `xxxxx` so you can try the repeat visitor experience. 

To use a launch option, you have to overwrite the `setupWithError` method

```swift
	override func setUpWithError() throws {
		
		app.launchArguments.append("-updateRequired")
		try super.setUpWithError()
	}
```



## Technical documentation

Each of the tests is an extention of the BaseFlowTest. That will launch the application with the `-resetOnStart` and `-disableTranstions` options. Each test basically consists of **assertions** and **actions**. 

Assertions is checking if a certain text exist. They are stored in an extension to the BaseFlowTest, so they can be reused across the different test. 

```swift
	/// Are we on the pincode screen?
	func assertPincodeScreen() {
		app.textExists("pincode.heading") // Language Key
    // OR
    app.textExists("Je kunt je toegangscode niet aanpassen") // Language Value
	}
```

You can use the textExits method with the language value like `Je kunt je toegangscode niet aanpassen`, or with the language key like `pincode.heading`. When using the language key, you might have to add a `accessibilityIdentifier` to the exiting element on the view like:

```swift
Text("pincode.heading")
	.accessibilityIdentifier("pincode.heading")
```

Actions are taps on buttons. The can be triggered with

```swift
app.buttons["pincode.forgot"].tap()
```

where you can use the language key or the language value. (Where you might have to repeat to add the `accessibilityIdentifier`)

```swift
Button(action: {
  viewModel.reduce(.forgotPinCode)
}, label: {
  Text("pincode.forgot")
})
  .buttonStyle(LinkButtonStyle())
	.padding(ViewTraits.ForgotButton.insets)
	.accessibilityIdentifier("pincode.forgot")
```



## Flows

### Creating your Pincode

There are three flows to test when creating a pincode:

- The pincode is too weak
- The pincode is good, but the confirmation of the pincode is wrong
- The pincode is good, the confirmation is good

### Forgot Pincode

There are four flows to test when for forgotten pincode:

- User presses the cancel button
- User closes the sheet with the close icon (We can not test the drag down to close option)
- User pressed the create new account button, and cancels the dialog
- User pressed the create new account button, and accepts the dialog

### Update Required

Just one flow to test here, user taps the download now button

### Search Organisation

For now, just one complete flow test:

- user enters the pincode,

-  user does DigiD login,

-  user searches for "Tandarts" in "Breda",

-  user clicks on the first result, 

- user confirms there is a healthcare organisation added to the overview.

  

Other unhappy paths will be added later.



