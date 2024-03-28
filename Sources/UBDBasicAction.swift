//
//  UBDBasicAction.swift
//
//
//  Created by Peteranny on 2024/3/11.
//

public enum UBDBasicAction<Element> {
    case launch

    case wait(for: Element, to: State)
    public enum State {
        /// This is a strictly negated state when we expect an element to be *never* so.
        /// For example, the onboarding tutorial *never appears* when I re-visit the same page.
        /// Compared to *disappear*, which allows it to appear.
        indirect
        case never(State)

        case appear
        case disappear
        case beSelected
        case beDeselected
        case beEnabled
        case beDisabled
        case haveValue(Any?)
    }

    case tap(on: Element)
    case tapToEnter(String, on: Element)
    case tapToSwitch(SwitchState, on: Element)
    public enum SwitchState {
        case on, off
    }

    case doubleTap(on: Element)
    case longPress(on: Element)
    case swipe(Direction, on: Element)
    case scroll(Direction, on: Element)
    public enum Direction {
        case up, down, left, right
    }
}

extension UBDBasicAction.Direction {
    var reverse: Self {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
