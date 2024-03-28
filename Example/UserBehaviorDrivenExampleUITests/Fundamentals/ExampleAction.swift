//
//  ExampleAction.swift
//  UserBehaviorDrivenExampleUITests
//
//  Created by Peteranny on 2024/3/6.
//

import UBDTestKit

/// Extended actions that comprise basic actions to achieve strong intentions
enum ExampleAction {
    case landingScreen(LandingScreenAction)
    enum LandingScreenAction {
        case login(account: String, password: String)
    }

    case loginScreen(LoginScreenAction)
    enum LoginScreenAction {
        case login(account: String, password: String)
        case verifyDoubleTap
        case verifyLongPress
    }
}

/// The base test case of all other tests to access the extended actions in addition to the basic actions
typealias ExampleTestCase = UBDTestCase<ExampleElement>

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

        case .loginScreen(.verifyDoubleTap):
            then(.doubleTap(on: .loginScreen(.this)))
            then(.wait(for: .loginScreen(.alert(.doubleTapped)), to: .appear))
            then(.tap(on: .loginScreen(.alert(.okButton))))

        case .loginScreen(.verifyLongPress):
            then(.longPress(on: .loginScreen(.this)))
            then(.wait(for: .loginScreen(.alert(.longPressed)), to: .appear))
            then(.tap(on: .loginScreen(.alert(.okButton))))
        }
    }
}
