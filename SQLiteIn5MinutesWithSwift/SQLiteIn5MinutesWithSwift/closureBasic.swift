//
//  closureMinimal.swift
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
// int main(int argc, char **argv) {
func sqlQueryClosureBasic(argc argc: Int, argv: [String]) -> Int {
    var db: sqlite3 = nil 
    var zErrMsg:CCharPointer = nil
    var rc: Int32 = 0
    
    if argc != 3 {
        print(String(format: "ERROR: Usage: %s DATABASE SQL-STATEMENT", argv[0]))
        return 1
    }
    
    rc = sqlite3_open(argv[1], &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String.fromCString(sqlite3_errmsg(db))! ?? "" )
        sqlite3_close(db)
        return 1
    }
    
    rc = sqlite3_exec(
        db,      // database 
        argv[2], // statement
        {        // callback: non-capturing closure
            resultVoidPointer, columnCount, values, columns in
            
            for i in 0 ..< Int(columnCount) {
                guard let value = String.fromCString(values[i]) else {
                    print("No value")
                    continue
                }
                
                guard let column = String.fromCString(columns[i]) else {
                    print("No column")
                    continue
                }
                print("\(column) = \(value)")
            }
            return 0
        }, 
        nil, 
        &zErrMsg
    )
    
    if rc != SQLITE_OK {
        let errorMsg = String.fromCString(zErrMsg)! ?? ""
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(zErrMsg)
    }
    
    sqlite3_close(db)
    return 0
}
