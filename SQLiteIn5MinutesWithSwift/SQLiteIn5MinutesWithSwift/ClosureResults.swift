//
//  ClosureResults.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

/**
 Query result as an array of rows. Each row is a Dictionary of column:value pairs.
 */
class Result {
    class Row {
        var data: [String: String]
        init() { self.data = [:] }
    }
    
    var rows: [Row]
    init() { self.rows = [] }
}

func sqlQueryClosureWithResults(path: String, sql: String) -> [Result.Row] {
    var db: sqlite3? = nil 
    var errorMessage: CCharPointer? = nil
    var resultcode: Int32 = 0
        
    resultcode = sqlite3_open(path, &db)
    if  resultcode != 0 {
        print("ERROR: sqlite3_open " + String(cString: sqlite3_errmsg(db)) )
        sqlite3_close(db)
        return []
    }
        
    let resultPointer = UnsafeMutablePointer<Result>.allocate(capacity: 1)
    var result = Result()
    resultPointer.initialize(from: &result, count: 1) // :!!!:???: .deallocate somewhere?

    resultcode = sqlite3_exec(
        db,  // opened database: sqlite3* … OpaquePointer
        sql, // SQL statement: const char *sql … UnsafePointer<CChar> … UnsafePointer<Int8> 
        {    // callback, non-capturing closure: int (*callback)(void*,int,char**,char**)
            param,        // void* … UnsafeMutableRawPointer?
            columnCount,  // int
            values,       // char** … UnsafeMutablePointer< UnsafeMutablePointer<CChar>? >?
            columns       // char** … UnsafeMutablePointer< UnsafeMutablePointer<CChar>? >?
            in
            
            guard let p: UnsafeMutableRawPointer = param else {
                    return -1
            }
            let resultPointer = p.bindMemory(to: Result.self, capacity: 1)
            let result = resultPointer.pointee
            
            let row = Result.Row()
            if let columns = columns, let values = values {
                for i in 0 ..< Int(columnCount) {
                    guard let value = values[i],
                    let valueStr = String(validatingUTF8: value) else {
                        print("No value")
                        continue
                    }
                    
                    guard let column = columns[i],
                    let columnStr = String(validatingUTF8: column) else {
                        print("No column")
                        continue
                    }
                    
                    row.data[columnStr] = valueStr
                }
            }
            
            result.rows.append(row)
            return 0
        }, 
        resultPointer, // param, 1st argument to callback: void* … UnsafeMutableRawPointer? 
        &errorMessage  // Error msg written here:   char **errmsg 
    )
    
    if resultcode != SQLITE_OK {
        let errorMsg = String(cString: errorMessage!)
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(errorMessage)
    }
    
    sqlite3_close(db)
    return result.rows
}
