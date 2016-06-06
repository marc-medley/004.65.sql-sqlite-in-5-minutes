//
//  main.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

// READABLE typedef
typealias sqlite3 = COpaquePointer
typealias CCharHandle = UnsafeMutablePointer<UnsafeMutablePointer<CChar>>
typealias CCharPointer = UnsafeMutablePointer<CChar>
typealias CVoidPointer = UnsafeMutablePointer<Void>

// SETUP DATABASE
var argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "DROP TABLE people;"
]
sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "CREATE TABLE people (name TEXT, date_of_birth DATETIME, tickets INTEGER, balance REAL);"
]
sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "INSERT INTO people VALUES ('Jay', '1977-01-01', 0, 0);"
]
sqlCommand(argc: argv.count, argv: argv)

argv = ["sqlCommand", 
        "example.sqlitedb", 
        "INSERT INTO people VALUES ('Kay', '1988-05-09', 1, 10.00);"]
sqlCommand(argc: argv.count, argv: argv)

sqlCommand(
    path: "example.sqlitedb", 
    sql: "INSERT INTO people VALUES ('Zay', '2000-01-01', 2, 55.23);"
)

// EXAMPLE CallbackBasic.swift: Basic C-Style Callback
print(":: Query Database, Basic Callback ::")
argv = ["sqlQueryCallbackBasic", 
        "example.sqlitedb", 
        "SELECT * FROM people;"]
sqlQueryCallbackBasic(argc: argv.count, argv: argv)

// EXAMPLE ClosureBasic.swift: Basic Closure
print("\n:: Query Database, Basic Closure ::")
sqlQueryClosureBasic(argc: argv.count, argv: argv)

// EXAMPLE: ClosureResults.swift: Closure with 
print("\n:: Query Database, Closure with Results Array ::")
let results = sqlQueryClosureWithResults(
    path: "example.sqlitedb", 
    sql: "SELECT * FROM people;"
)
print(":: Results Array ::")
for r in results {
    print(r.data)
}

// EXAMPLE: Details.swift: Closure with prepare, step, column, and finalize
print("\n:: Query Database. Details prepare, step, column, and finalize ::")
sqlQueryDetails(
    path: "example.sqlitedb", 
    sql: "SELECT * FROM people;"
)

// EXAMPLE: SqlQuery.swift: Closure with prepare, step, column, and finalize
print("\n:: SqlQuery.swift. Prepare, bind, step, column, and finalize ::")
let sqlQuery = SqlQuery(path: "example.sqlitedb")
sqlQuery.statementPrepare("SELECT * FROM people WHERE name = :1;")
sqlQuery.statementBind(paramIndex: 1, paramValue: "Kay")
sqlQuery.statementExecute()
sqlQuery.databaseClose()

