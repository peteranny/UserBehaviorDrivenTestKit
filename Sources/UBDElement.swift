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
    let value: () -> String
    let tap: () -> Void
    let enter: (String) -> Void
}

extension UBDResolvedElement {
    public static func from(
        _ ele: XCUIElement,
        appears: @escaping (XCUIElement) -> Bool = Self.defaultAppears,
        value: @escaping (XCUIElement) -> String = Self.defaultValue,
        tap: @escaping (XCUIElement) -> Void = Self.defaultTap,
        enter: @escaping (XCUIElement, String) -> Void = Self.defaultEnter
    ) -> UBDResolvedElement {
        // Use the provided method/accessor or fall back to default
        return UBDResolvedElement(
            ele: ele,
            appears: { appears(ele) },
            value: { value(ele) },
            tap: { tap(ele) },
            enter: { enter(ele, $0) }
        )
    }
}

extension UBDResolvedElement {
    /// The default transformers. Update if you want a different implementation for the default.
    public static var defaultAppears: (XCUIElement) -> Bool = { $0.waitForExistence(timeout: 1) }
    public static var defaultValue: (XCUIElement) -> String = { $0.label }
    public static var defaultTap: (XCUIElement) -> Void = { $0.tap() }
    public static var defaultEnter: (XCUIElement, String) -> Void = { $0.typeText($1) }
}
