// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLiteIn5WithFluent",
    platforms: [
        .macOS(.v12),  // .macOS(.v12),
        .iOS(.v13)
    ],
    dependencies: [
        // fluent.git depends on vapor
        //.package(url: "https://github.com/vapor/fluent.git", from: "4.6.0"),
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.36.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "SQLiteIn5WithFluent",
            dependencies: [
                //.product(name: "Fluent", package: "fluent"),
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            ]),
        .testTarget(
            name: "SQLiteIn5WithFluentTests",
            dependencies: ["SQLiteIn5WithFluent"]),
    ]
)
