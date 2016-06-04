//
//  main.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation


typealias sqlite3 = COpaquePointer
typealias CCharHandle = UnsafeMutablePointer<UnsafeMutablePointer<CChar>>
typealias CCharPointer = UnsafeMutablePointer<CChar>
typealias CVoidPointer = UnsafeMutablePointer<Void>

var argv = [
    "sqlitetest", 
    "example.sqlitedb", 
    "DROP TABLE people;"
]
sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "CREATE TABLE people (name STRING, date_of_birth DATETIME, hobby STRING);"
]
sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "INSERT INTO people VALUES ('Jay', '1977-01-01', 'robotics');"
]
sqlCommand(argc: argv.count, argv: argv)

argv = ["sqlCommand", 
        "example.sqlitedb", 
        "INSERT INTO people VALUES ('Kay', '1988-05-09', 'music');"]
sqlCommand(argc: argv.count, argv: argv)

sqlCommand(
    path: "example.sqlitedb", 
    sql: "INSERT INTO people VALUES ('Zay', '2000-01-01', 'gadgets');"
)


print(":: Query Database, Basic Callback ::")
argv = ["sqlQueryCallbackBasic", 
        "example.sqlitedb", 
        "SELECT * FROM people;"]
sqlQueryCallbackBasic(argc: argv.count, argv: argv)

print("\n:: Query Database, Basic Closure ::")
sqlQueryClosureBasic(argc: argv.count, argv: argv)

print("\n:: Query Database, Closure with Results Array ::")
let results = sqlQueryClosureWithResults(
    path: "example.sqlitedb", 
    sql: "SELECT * FROM people;"
)
print(":: Results Array ::")
for r in results {
    print(r.data)
}
