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

        case let .wait(for: ele, to: .appear):
            XCTAssertTrue(ele.resolve().appears())

        case let .wait(for: ele, to: .disappear):
            XCTAssertFalse(ele.resolve().appears())

        case let .wait(for: ele, to: .beSelected):
            XCTAssertTrue(ele.resolve().selected())

        case let .wait(for: ele, to: .beDeselected):
            XCTAssertFalse(ele.resolve().selected())

        case let .wait(for: ele, to: .haveValue(value)):
            XCTAssertEqual(ele.resolve().value(), value)

        case let .tap(ele):
            ele.resolve().tap()

        case let .tapToEnter(text, ele):
            then(.tap(on: ele))
            ele.resolve().enter(text)

        case let .tapToSwitch(state, on: ele):
            then(.tap(on: ele))
            then(.wait(for: ele, to: state == .on ? .beSelected : .beDeselected))

        case let .doubleTap(on: ele):
            ele.resolve().doubleTap()

        case let .swipe(direction, on: ele):
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
            then(.swipe(direction.reverse, on: ele))
        }
    }
}
