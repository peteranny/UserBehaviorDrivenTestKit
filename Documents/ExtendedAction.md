## Extended Actions

Some consecutive basic actions in a particular screen could be common. To make common action series reusable, we can define ad-hoc actions for screens, whose handler is expected to comprise basic actions to achieve some strong intention.

For instance, in the login screen, user always has to tap the text fields to enter the account and the password, followed by hitting the submit button in order to proceed. We can make an extended login action for an easier call:

```swift
import UBDTestKit

// MARK: - Extended actions
enum ExampleAction {
  case landingScreen(LandingScreenAction)
  enum LandingScreenAction {
    case login(account: String, password: String)
  }

  case loginScreen(LoginScreenAction)
  enum LoginScreenAction {
    case login(account: String, password: String)
  }
}

// MARK: - Extended action handlers.
// Make use of basic actions to achieve some strong intention.
extension UBDTestCase where Element == ExampleElement {
  func then(_ action: ExampleAction) {
    switch action {
    case let .landingScreen(.login(account, password)):
      then(.tap(on: .landingScreen(.loginButton)))
      then(.wait(for: .loginScreen(.this), to: .appear))
      then(.loginScreen(.login(account: account, password: password)))
      then(.wait(for: .loginScreen(.this), to: .disappear))

    case let .loginScreen(.login(account, password)):
      then(.tapToEnter(account, on: .loginScreen(.accountField)))
      then(.tapToEnter(password, on: .loginScreen(.passwordField)))
      then(.tap(on: .loginScreen(.submitButton)))
    }
  }
}
```
And then apply the extended action to the test:
```swift
import UBDTestKit
import XCTest

final class ExampleBehaviorDrivenUITests: UBDTestCase<ExampleElement> {
  func testScreenSpecificActions() throws {
    then(.launch)
    then(.wait(for: .landingScreen(.this), to: .appear))
    then(.landingScreen(.login(account: "P.S@g.com", password: "000000"))) // <-- one action for a complete intention
    then(.wait(for: .landingScreen(.welcome), to: .haveValue("Welcome back, P.S@g.com!")))
  }
}
```
