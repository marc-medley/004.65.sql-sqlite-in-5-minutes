// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLiteIn5WithSwift",
    platforms: [
        .macOS(.v10_15),  // .macOS(.v12),
        .iOS(.v13)
    ],
    dependencies: [
        //.package(url: "https://github.com/vapor/fluent.git", from: "4.6.0"),
        //.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "SQLiteIn5WithSwift",
            dependencies: [
                //.product(name: "Fluent", package: "fluent"),
                //.product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            ]),
        .testTarget(
            name: "SQLiteIn5WithSwiftTests",
            dependencies: ["SQLiteIn5WithSwift"]),
    ]
)
