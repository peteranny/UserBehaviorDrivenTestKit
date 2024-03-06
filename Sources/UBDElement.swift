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
        appears: @escaping (XCUIElement) -> Bool = { $0.waitForExistence(timeout: 1) },
        value: @escaping (XCUIElement) -> String = { $0.label },
        tap: @escaping (XCUIElement) -> Void = { $0.tap() },
        enter: @escaping (XCUIElement, String) -> Void = { $0.typeText($1) }
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
