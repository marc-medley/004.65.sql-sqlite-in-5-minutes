//
//  Commands.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation
import SQLite3

// - note: Use for SQL statement which does not return any query result.
//
// - parameter argc: C-style argument count
// - parameter argv: C-style argument values array
// - returns: integer result code. 0 for success.
func sqlCommand(argc: Int, argv: [String]) -> Int {
    var db: sqlite3? = nil // sqlite3 *db;
    var zErrMsg:CCharPointer? = nil
    var rc: Int32 = 0 // result code
    
    if argc != 3 {
        print(String(format: "ERROR: Usage: %s DATABASE SQL-STATEMENT", argv[0]))
        return 1
    }
    
    rc = sqlite3_open(argv[1], &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String(cString: sqlite3_errmsg(db)) )
        sqlite3_close(db)
        return 1
    }

    rc = sqlite3_exec(db, argv[2], nil, nil, &zErrMsg)
    if rc != SQLITE_OK {
        print("ERROR: sqlite3_exec " + String(cString: zErrMsg!))
        sqlite3_free(zErrMsg)
    }
    
    sqlite3_close(db)
    return 0
}

/// - note: Use for SQL statement which does not return any query result.
/// 
/// - parameter path: /path/to/some/database.sqlitedb
/// - parameter sql: non-query SQL statement
/// - returns: integer result code. 0 for success
func sqlCommand(path: String, sql: String) -> Int {
    var db: sqlite3? = nil // sqlite3 *db;
    var zErrMsg:CCharPointer? = nil
    var rc: Int32 = 0 // result code
        
    rc = sqlite3_open(path, &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String(cString: sqlite3_errmsg(db)) )
        sqlite3_close(db)
        return 1
    }
    
    rc = sqlite3_exec(db, sql, nil, nil, &zErrMsg)
    if rc != SQLITE_OK {
        print("ERROR: sqlite3_exec " + String(cString: zErrMsg!) )
        sqlite3_free(zErrMsg)
    }
    
    sqlite3_close(db)
    return 0
}
