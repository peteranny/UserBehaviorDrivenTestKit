//
//  ExampleElement.swift
//  UserBehaviorDrivenExampleUITests
//
//  Created by Peteranny on 2024/3/6.
//

import UBDTestKit

/// The elements that user interacts with
enum ExampleElement {
    case landingScreen(LandingScreenElement)
    enum LandingScreenElement {
        case this
        case loginButton
        case welcome
        case welcomeAccount
    }

    case loginScreen(LoginScreenElement)
    enum LoginScreenElement {
        case this
        case accountField
        case passwordField
        case submitButton

        case alert(AlertElement)
        enum AlertElement {
            case incorrect
            case doubleTapped
            case okButton
        }
    }
}

import XCTest

/// The resolver that translate the elements into the internal implementation
extension ExampleElement: UBDElement {
    func resolve() -> UBDResolvedElement {
        switch self {
        case .landingScreen(let ele):
            return resolve(ele)
        case .loginScreen(let ele):
            return resolve(ele)
        }
    }

    /// The resolver of elements in the landing screen
    private func resolve(_ ele: ExampleElement.LandingScreenElement) -> UBDResolvedElement {
        let app = XCUIApplication()
        switch ele {
        case .this:
            return .from(app.buttons["Log In"])
        case .loginButton:
            return .from(app.buttons["Log In"])
        case .welcome:
            return .from(app.staticTexts["welcome.label"])
        case .welcomeAccount:
            return .from(app.staticTexts["welcome.label"],
                         value: { String($0.label.trimmingPrefix("Welcome back, ").dropLast()) }) // <-- customize the value extraction
        }
    }

    /// The resolver of elements in the login screen
    private func resolve(_ ele: ExampleElement.LoginScreenElement) -> UBDResolvedElement {
        let app = XCUIApplication()
        switch ele {
        case .this:
            return .from(app.staticTexts["Enter You Information"],
                         swipeDown: {
                let top = $0.coordinate(withNormalizedOffset: .zero)
                let bottom = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 1))
                top.press(forDuration: 1, thenDragTo: bottom)
            })
        case .accountField:
            return .from(app.textFields["account"])
        case .passwordField:
            return .from(app.secureTextFields["password"])
        case .submitButton:
            return .from(app.buttons["Submit"])
        case .alert(.incorrect):
            return .from(app.alerts["Incorrect"])
        case .alert(.doubleTapped):
            return .from(app.alerts["Double Tapped"])
        case .alert(.okButton):
            return .from(app.alerts.buttons["OK"])
        }
    }
}
