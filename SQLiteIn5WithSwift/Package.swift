// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLiteIn5WithSwift",
    platforms: [
        .macOS(.v10_15),  // .macOS(.v12),
        .iOS(.v13)        // .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, 
        // and make them visible to other packages.
        .executable(
            name: "SQLiteIn5WithSwift",
            targets: ["SQLiteIn5WithSwift"]),
        .library(
            name: "CSQLite",
            targets: ["CSQLite"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/vapor/fluent.git", from: "4.6.0"),
        //.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. 
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package, 
        // and on products in packages this package depends on.
        
        // linux> sudo apt policy libsqlite3-dev
        // linux> sudo apt install libsqlite3-dev
        // linux> sudo apt install sqlite3-doc
        // macos> brew info sqlite3
        // macos> brew install sqlite3
        .systemLibrary(name: "CSQLite", providers: [
            .apt(["libsqlite3-dev"]),
            .brew(["sqlite3"])
        ]),
        .executableTarget(
            name: "SQLiteIn5WithSwift",
            dependencies: [
                //.product(name: "CSQLite"),
                .target(name: "CSQLite"),
            ]),
        .testTarget(
            name: "SQLiteIn5WithSwiftTests",
            dependencies: ["SQLiteIn5WithSwift"]),
    ]
)
