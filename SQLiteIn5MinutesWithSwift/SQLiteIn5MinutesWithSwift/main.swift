//
//  main.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

// READABLE typedef
typealias sqlite3 = OpaquePointer
typealias CCharHandle = UnsafeMutablePointer<UnsafeMutablePointer<CChar>>
typealias CCharPointer = UnsafeMutablePointer<CChar>
typealias CVoidPointer = UnsafeMutableRawPointer

// SETUP DATABASE BEGINS ... exec non-callback commands open, create table & insert data
var argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "DROP TABLE IF EXISTS people;"
]
_ = sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "CREATE TABLE people (name TEXT, date_of_birth DATETIME, tickets INTEGER, balance REAL);"
]
_ = sqlCommand(argc: argv.count, argv: argv)

argv = [
    "sqlCommand", 
    "example.sqlitedb", 
    "INSERT INTO people VALUES ('Jay', '1977-01-01', 0, 0);"
]
_ = sqlCommand(argc: argv.count, argv: argv)

argv = ["sqlCommand", 
        "example.sqlitedb", 
        "INSERT INTO people VALUES ('Kay', '1988-05-09', 1, 10.00);"]
_ = sqlCommand(argc: argv.count, argv: argv)

_ = sqlCommand(
    path: "example.sqlitedb", 
    sql: "INSERT INTO people VALUES ('Zay', '2000-01-01', 2, 55.23);"
)
// SETUP DATABASE COMPLETE.

// EXAMPLE CallbackBasic.swift: Basic C-Style Callback
print(":: Query Database, Basic Callback ::")
argv = ["sqlQueryCallbackBasic", 
        "example.sqlitedb", 
        "SELECT * FROM people;"]
_ = sqlQueryCallbackBasic(argc: argv.count, argv: argv)

// EXAMPLE ClosureBasic.swift: Basic Closure
print("\n:: Query Database, Basic Closure ::")
_ = sqlQueryClosureBasic(argc: argv.count, argv: argv)

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
_ = sqlQuery.statementPrepare("SELECT * FROM people WHERE name = :1;")
_ = sqlQuery.statementBind(paramIndex: 1, paramValue: "Kay")
sqlQuery.statementExecute()
sqlQuery.databaseClose()

