//
//  ClosureBasic.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

/**
 - parameter argc: C-style argument count
 - parameter argv: C-style argument values array
 - returns: integer result code. 0 for success.
 */
func sqlQueryClosureBasic(argc: Int, argv: [String]) -> Int {
    var db: sqlite3? = nil 
    var zErrMsg:CCharPointer? = nil
    var rc: Int32 = 0
    
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
    
    rc = sqlite3_exec(
        db,      // opened database: sqlite3* … OpaquePointer
        argv[2], // SQL statement: const char *sql … UnsafePointer<Int8> … UnsafePointer<CChar>
        {        // callback, non-capturing closure: int (*callback)(void*,int,char**,char**)
            resultVoidPointer, // void* 
            columnCount,       // int
            values,            // char** … UnsafeMutablePointer< UnsafeMutablePointer<Int8>? >?
            names              // char** … UnsafeMutablePointer< UnsafeMutablePointer<Int8>? >?
            in
            
            // resultVoidPointer is unused
            
            if let names = names, let values = values {
                for i in 0 ..< Int(columnCount) {
                    guard let columnValue = values[i],
                        let columnValueStr = String(validatingUTF8: columnValue) else {
                            print("No UTF8 column value")
                            continue
                    }
                    
                    guard let columnName = names[i],
                    let columnNameStr = String(validatingUTF8: columnName) else {
                        print("No column name")
                        continue
                    }
                    print("\(columnNameStr) = \(columnValueStr)")
                }
            }
            return 0 // -> Int32
    }, 
        nil,       // param, 1st argument to callback: void* … UnsafeMutableRawPointer?
        &zErrMsg   // Error msg written here:   char **errmsg 
    )
    
    if rc != SQLITE_OK {
        let errorMsg = String(cString: zErrMsg!)
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(zErrMsg)
    }
    
    sqlite3_close(db)
    return 0
}
