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
        case appear
        case disappear
        case beSelected
        case beDeselected
        case haveValue(String)
    }

    case tap(on: Element)
    case tapToEnter(String, on: Element)
    case tapToSwitch(SwitchState, on: Element)
    public enum SwitchState {
        case on, off
    }

    case doubleTap(on: Element)
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
