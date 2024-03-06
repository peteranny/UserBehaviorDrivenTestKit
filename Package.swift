// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UBDTestKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "UBDTestKit", targets: ["UBDTestKit"]),
    ],
    targets: [
        .target(name: "UBDTestKit", path: "Sources"),
        .testTarget(name: "UBDTestKitTests", dependencies: ["UBDTestKit"]),
    ]
)
