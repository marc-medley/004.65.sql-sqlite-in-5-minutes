//
//  CallbackBasic.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

/// callback function pointer needs to be a global level function
func callback(
    _ resultVoidPointer: CVoidPointer, // void *NotUsed 
    columnCount: CInt,               // int argc
    values: CCharHandle,             // char **argv     
    columns: CCharHandle             // char **azColName
    ) -> CInt {
    for  i in 0 ..< Int(columnCount) {
        guard let value = String(validatingUTF8: values[i]) else {
            print("No value")
            continue
        }
        guard let column = String(validatingUTF8: columns[i]) else {
            print("No column")
            continue
        }
        print("\(column) = \(value)")
    }
    return 0 // 0 == status ok
}

/**
 - parameter argc: C-style argument count
 - parameter argv: C-style argument values array
 - returns: integer result code. 0 for success.
 */
func sqlQueryCallbackBasic(argc: Int, argv: [String]) -> Int {
    var db: sqlite3? = nil 
    var zErrMsg:CCharPointer? = nil
    var rc: Int32 = 0 // result code
    
    if argc != 3 {
        print(String(format: "ERROR: Usage: %s DATABASE SQL-STATEMENT", argv[0]))
        return 1
    }
    
    rc = sqlite3_open(argv[1], &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String(cString: sqlite3_errmsg(db)) ?? "" )
        sqlite3_close(db)
        return 1
    }
    
    rc = sqlite3_exec(db, argv[2], callback, nil, &zErrMsg)
    if rc != SQLITE_OK {
        print("ERROR: sqlite3_exec " + String(cString: zErrMsg!) ?? "")
        sqlite3_free(zErrMsg)
    }
    
    sqlite3_close(db)
    return 0
}
