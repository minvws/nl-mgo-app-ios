# End 2 End Tests

The [Robot Pattern](https://github.com/JamesSedlacek/Scrumdinger/blob/main/ScrumdingerUITests/ROBOT-PATTERN-README.md) is a UI testing strategy that abstracts interactions with the app into reusable, structured "robot" classes. Instead of writing UI tests directly with raw `XCUIApplication` calls, robots encapsulate actions and verifications, making tests more readable, maintainable, and modular. 

---

## How It Works  

### 1. Each screen or flow has its own robot
- A robot is a helper class responsible for interacting with a specific part of the app (e.g., `LoginRobot`, `IntroductionRobot`).
- It provides high-level methods like `tapNextButton()` or `tapReferenceButton()`, abstracting away raw UI interactions.

### 2. Tests chain robot methods for clarity
- Each robot method returns the robot for the next part of the flow. This could be the same robot if the test continues on the same screen or a different robot if the test moves to another part of the app.  
- This makes tests fluent and readable, ensuring each step naturally leads to the next.  

#### Example:  
```swift
AppRobot()
    .launchApp(withPincode: "12345") // Returns PincodeRobot
    .enterConfirmationPinCode("12345") // Returns LoginRobot
    .tapDigiDButton() // Returns MockDigiDRobot
    .performDigiDLogin() // Returns AddOrganizationRobot
    .enterSearchFields(name: "Huisarts", place: "Breda") // Stays on AddOrganizationRobot
    .tapSearchButton() // Returns OrganizationListManualRobot
```

## The Elements of a Robot

- **Broken into Elements, Verifications, and Actions**
  A robot is structured around three key components:
  - **Elements**: The UI components the robot interacts with (e.g., buttons, text fields).
  - **Verifications**: Methods to check the state of the UI (e.g., `verifySubHeadingExists()`).
  - **Actions**: Methods that perform actions on the UI (e.g., `tapSearchButton()`).

- **Each Robot has an `init` Validating We Are on the Correct Screen**  
  The `init` method of each robot ensures that the app is in the correct screen state when the robot is instantiated. If not, it performs the necessary navigation or throws an error. This removes the need for explicit validation methods in the test, simplifying the flow and making the test code cleaner.

## The App Robot

At the core of the pattern is the AppRobot, responsible for launching the app and returning the robot for the initial screen. Every test starts by creating an `AppRobot`, ensuring a consistent entry point.

The `AppRobot` also manages common launch flows. For example, it includes `startWithBGZ()`, which not only launches the app but also adds the Mock BGZ Healthcare Organization. This makes it easy for tests that rely on this setup to use a standardized launch sequence.

## Launch Options

- `-resetOnStart` will clear any existing data and create a first visit experience
- `-disableTransitions` will speedup animation and navigation
- `-updateRequired` will force the update required flow by mocking the remote configuration
- `-pincode:xxxxx` will set the pincode to `xxxxx` so you can try the repeat visitor experience.

To use a launch option, you have to create helper method for `AppRobot` method

```swift
/// Launch the application
/// - Returns: Introduction Robot for the first scene
@discardableResult
func launchApp() -> IntroductionRobot {
	app.launchArguments.append("-resetOnStart")
	app.launchArguments.append("-disableTransitions")
	app.launch()
	return IntroductionRobot(app)
}
```
---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

