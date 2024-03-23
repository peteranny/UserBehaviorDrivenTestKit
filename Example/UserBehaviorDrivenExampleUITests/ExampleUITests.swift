//
//  ExampleUITests.swift
//  UserBehaviorDrivenExampleUITests
//
//  Created by Peteranny on 2024/3/6.
//

import UBDTestKit
import XCTest

final class ExampleUITests: ExampleTestCase {
    /// Native UITest
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Log In"].waitForExistence(timeout: 1))
        app.buttons["Log In"].tap()
        XCTAssertTrue(app.staticTexts["Enter You Information"].waitForExistence(timeout: 1))
        app.textFields["account"].tap()
        app.textFields["account"].typeText("P.S@g.com")
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("888888")
        app.buttons["Submit"].tap()
        XCTAssertTrue(app.alerts["Incorrect"].waitForExistence(timeout: 1))
        app.alerts.buttons["OK"].tap()
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("000000")
        app.buttons["Submit"].tap()
        XCTAssertFalse(app.staticTexts["Enter You Information"].waitForExistence(timeout: 1))
        XCTAssertEqual(app.staticTexts["welcome.label"].label, "Welcome back, P.S@g.com!")
    }

    /// User-behavior driven UITest
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
        then(.wait(for: .landingScreen(.welcome), to: .haveValue("Welcome back, P.S@g.com!")))
    }

    /// User-behavior driven UITest with extended actions
    func testExampleUserBehaviorDrivenWithExtendedActions() throws {
        then(.launch)
        then(.wait(for: .landingScreen(.this), to: .appear))
        then(.landingScreen(.login(account: "P.S@g.com", password: "000000"))) // <-- one action for a complete intention in the screen
        then(.wait(for: .landingScreen(.welcomeAccount), to: .haveValue("P.S@g.com")))
    }

    /// User-behavior driven UITest with more actions
    func testExampleUserBehaviorDrivenWithMoreActions() throws {
        then(.launch)
        then(.wait(for: .landingScreen(.this), to: .appear))
        then(.tap(on: .landingScreen(.loginButton)))
        then(.wait(for: .loginScreen(.this), to: .appear))
        then(.loginScreen(.verifyDoubleTap))
    }
}
