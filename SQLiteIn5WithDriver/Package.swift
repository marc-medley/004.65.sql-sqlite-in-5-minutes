// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLiteIn5WithDriver",
    platforms: [
        .macOS(.v10_15),  // .macOS(.v12),
        .iOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.3.0"),
        
        // added for FluentBenchmark
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.27.0"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "SQLiteIn5WithDriver",
            dependencies: [
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "SQLiteKit", package: "sqlite-kit"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            ]),
        .testTarget(
            name: "SQLiteIn5WithDriverTests",
            dependencies: [
                //.product(name: "FluentBenchmark", package: "fluent-kit"),
                //.target(name: "SQLiteIn5WithDriver"),
                "SQLiteIn5WithDriver",
            ]),
    ]
)
