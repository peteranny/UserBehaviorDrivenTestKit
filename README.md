# UBDTestKit

UserBehaviorDrivenTestKit - A Swift framework simplifying UITests by adopting a user-behavior driven pattern.

## Introduction

UBDTestKit aims to make writing UITests more intuitive, efficient, and fun by focusing on user intentions and serialization of interactions into a clear and readable series of actions on associated elements.

## Features

- Enhanced Readability: Describe tests in a human-readable and intuitive format.
- Increased Maintainability: Encourages reuse and easy addition of new actions or elements.
- Reduced UI Dependence: Minimizes the influence of updates to internal XCUIElement implementation on the tests.

## Installation

### Swift Package Manager

1. In Xcode, select "File" -> "Add Packages..."
2. Paste the git URL (`https://github.com/peteranny/UserBehaviorDrivenTestKit.git`) in the search box
3. Follow the on-screen instructions to add the dependency
4. Include `import UBDTestKit` at the top of your Swift files to start using the framework

## Usage

First off, define the elements that user interacts with in the app:
```swift
import UBDTestKit

enum ExampleElement {
    case landingScreen(LandingScreenElement)
    enum LandingScreenElement {
        case this
        case loginButton
        case welcomeAccount
    }

    case loginScreen(LoginScreenElement)
    enum LoginScreenElement {
        case this
        case accountField
        case passwordField
        case submitButton
    }
}
```

Secondly, interpret the elements under the hood:

```swift
import XCTest

extension ExampleElement: UBDElement {
    func resolve() -> UBDResolvedElement {
        let app = XCUIApplication()
        switch self {
        case .landingScreen(.this):
            return .from(app.buttons["Log In"])
        case .landingScreen(.loginButton):
            return .from(app.buttons["Log In"])
        case .landingScreen(.welcomeAccount):
            return .from(app.staticTexts["welcome.label"],
                         value: { String($0.label.trimmingPrefix("Welcome back, ")) })
        case .loginScreen(.this):
            return .from(app.staticTexts["Enter You Information"])
        case .loginScreen(.accountField):
            return .from(app.textFields["account"])
        case .loginScreen(.passwordField):
            return .from(app.secureTextFields["password"])
        case .loginScreen(.submitButton):
            return .from(app.buttons["Submit"])
        }
    }
}
```

Finally, subclass `UBDTestCase` to start writing your test in a user-behavior driven flow:

```swift
final class ExampleUITests: UBDTestCase<ExampleElement> {
    func testExampleUserBehaviorDriven() throws {
        then(.launch)
        then(.wait(for: .landingScreen(.this), to: .appear))
        then(.tap(on: .landingScreen(.loginButton)))
        then(.wait(for: .loginScreen(.this), to: .appear))
        then(.tapToEnter("P.S@g.com", on: .loginScreen(.accountField)))
        then(.tapToEnter("888888", on: .loginScreen(.passwordField)))
        then(.tap(on: .loginScreen(.submitButton)))
        then(.wait(for: .loginScreen(.alert(.incorrect)), to: .appear))
        then(.tap(on: .loginScreen(.alert(.okButton))))
        then(.tapToEnter("000000", on: .loginScreen(.passwordField)))
        then(.tap(on: .loginScreen(.submitButton)))
        then(.wait(for: .loginScreen(.this), to: .disappear))
        then(.wait(for: .landingScreen(.welcomeAccount), to: .haveValue("P.S@g.com")))
    }
}
```

To group a series of basic action into an extended action, please refer to [Extend Actions](Documents/ExtendedAction.md) for the guidance.

To learn more about the user-behavior driven pattern, visit [this article](https://medium.com/@tingyishih/user-behavior-driven-xcuitests-f078d6ab5ffe) for more information.

## Demonstration

This framework comes with a demo app that shows more usage of the framework. To run the demo:

1. Open the `UserBehaviorDrivenUITestsExample` project in Xcode
2. Go to `ExampleUITests.swift` in the project navigator
3. Run the tests to observe how the UITests are accomplished using actions defined in UBDTestKit

The code of the demo provides a useful guide for developers on how to structure their UITests using UBDTestKit, so be sure to check it out.
