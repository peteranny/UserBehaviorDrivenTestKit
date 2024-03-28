//
//  UBDTestCase.swift
//
//
//  Created by Peteranny on 2024/3/11.
//

import XCTest

open class UBDTestCase<Element: UBDElement>: XCTestCase {
    open override func setUpWithError() throws {
        try super.setUpWithError()

        self.continueAfterFailure = false
    }

    // MARK: - Action handlers
    public func then(_ action: UBDBasicAction<Element>) {
        let app = XCUIApplication()
        switch action {
        case .launch:
            app.launch()

        case .relaunch:
            app.terminate()
            then(.launch)

        case let .wait(for: ele, to: state):
            XCTAssertTrue(satisfies(ele.satisfies(state), forRetries: 3))

        case let .tap(ele):
            then(.wait(for: ele, to: .appear))
            ele.resolve().tap()

        case let .tapToEnter(text, ele):
            then(.wait(for: ele, to: .appear))
            then(.tap(on: ele))
            ele.resolve().enter(text)

        case let .tapToSwitch(state, on: ele):
            then(.wait(for: ele, to: .appear))
            then(.tap(on: ele))
            then(.wait(for: ele, to: state == .on ? .beSelected : .beDeselected))

        case let .doubleTap(on: ele):
            then(.wait(for: ele, to: .appear))
            ele.resolve().doubleTap()

        case let .longPress(on: ele):
            then(.wait(for: ele, to: .appear))
            ele.resolve().longPress()

        case let .swipe(direction, on: ele):
            then(.wait(for: ele, to: .appear))
            switch direction {
            case .up:
                ele.resolve().swipeUp()
            case .down:
                ele.resolve().swipeDown()
            case .left:
                ele.resolve().swipeLeft()
            case .right:
                ele.resolve().swipeRight()
            }

        case let .scroll(direction, on: ele):
            then(.wait(for: ele, to: .appear))
            then(.swipe(direction.reverse, on: ele))
        }
    }
}

private extension UBDElement {
    func satisfies(_ state: UBDBasicAction<Self>.State) -> Bool {
        switch state {
        case .never(let state):
            return UBDTestKit.satisfies(satisfies(state), forRetries: 3) == false
        case .appear:
            return resolve().appears()
        case .disappear:
            return !resolve().appears()
        case .beSelected:
            return resolve().selected()
        case .beDeselected:
            return !resolve().selected()
        case .beEnabled:
            return resolve().enabled()
        case .beDisabled:
            return !resolve().enabled()
        case .haveValue(let expectedValue):
            return "\(resolve().value())" == "\(expectedValue)"
        }
    }
}

private func satisfies(_ condition: @autoclosure () -> Bool, forRetries nRetries: Int) -> Bool {
    (1...nRetries).map { $0 == nRetries }.contains { isLast in
        if condition() { return true }
        if !isLast { usleep(useconds_t(500_000)) }
        return false
    }
}
