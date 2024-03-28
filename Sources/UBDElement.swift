//
//  UBDElement.swift
//
//
//  Created by Peteranny on 2024/3/11.
//

import XCTest

public protocol UBDElement {
    func resolve() -> UBDResolvedElement
}

// MARK: - Resolved element
// Defines how to perform a method or retrieve a value
public struct UBDResolvedElement {
    let ele: XCUIElement
    let appears: () -> Bool
    let selected: () -> Bool
    let enabled: () -> Bool
    let value: () -> Any?
    let tap: () -> Void
    let doubleTap: () -> Void
    let enter: (String) -> Void
    let swipeUp: () -> Void
    let swipeDown: () -> Void
    let swipeLeft: () -> Void
    let swipeRight: () -> Void
}

extension UBDResolvedElement {
    public static func from(
        _ ele: XCUIElement,
        appears: @escaping (XCUIElement) -> Bool = Self.defaultAppears,
        selected: @escaping (XCUIElement) -> Bool = Self.defaultSelected,
        enabled: @escaping (XCUIElement) -> Bool = Self.defaultEnabled,
        value: @escaping (XCUIElement) -> Any? = Self.defaultValue,
        tap: @escaping (XCUIElement) -> Void = Self.defaultTap,
        doubleTap: @escaping (XCUIElement) -> Void = Self.defaultDoubleTap,
        enter: @escaping (XCUIElement, String) -> Void = Self.defaultEnter,
        swipeUp: @escaping (XCUIElement) -> Void = Self.defaultSwipeUp,
        swipeDown: @escaping (XCUIElement) -> Void = Self.defaultSwipeDown,
        swipeLeft: @escaping (XCUIElement) -> Void = Self.defaultSwipeLeft,
        swipeRight: @escaping (XCUIElement) -> Void = Self.defaultSwipeRight
    ) -> UBDResolvedElement {
        // Use the provided method/accessor or fall back to default
        return UBDResolvedElement(
            ele: ele,
            appears: { appears(ele) },
            selected: { selected(ele) },
            enabled: { enabled(ele) },
            value: { value(ele) },
            tap: { tap(ele) },
            doubleTap: { doubleTap(ele) },
            enter: { enter(ele, $0) },
            swipeUp: { swipeUp(ele) },
            swipeDown: { swipeDown(ele) },
            swipeLeft: { swipeLeft(ele) },
            swipeRight: { swipeRight(ele) }
        )
    }
}

extension UBDResolvedElement {
    /// The default transformers. Update if you want a different implementation for the default.
    public static var defaultAppears: (XCUIElement) -> Bool = { $0.waitForExistence(timeout: 1) }
    public static var defaultSelected: (XCUIElement) -> Bool = { $0.elementType == .switch ? $0.value as? String == "1" : $0.isSelected }
    public static var defaultEnabled: (XCUIElement) -> Bool = { $0.isEnabled }
    public static var defaultValue: (XCUIElement) -> Any? = { [.staticText, .button].contains($0.elementType) ? $0.label : $0.value }
    public static var defaultTap: (XCUIElement) -> Void = { $0.tap() }
    public static var defaultDoubleTap: (XCUIElement) -> Void = { $0.doubleTap() }
    public static var defaultEnter: (XCUIElement, String) -> Void = { $0.typeText($1) }
    public static var defaultSwipeUp: (XCUIElement) -> Void = { $0.swipeUp() }
    public static var defaultSwipeDown: (XCUIElement) -> Void = { $0.swipeDown() }
    public static var defaultSwipeLeft: (XCUIElement) -> Void = { $0.swipeLeft() }
    public static var defaultSwipeRight: (XCUIElement) -> Void = { $0.swipeRight() }
}
