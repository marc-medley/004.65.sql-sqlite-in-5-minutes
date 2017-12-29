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
        print("ERROR: sqlite3_open " + String(cString: sqlite3_errmsg(db)) ?? "" )
        sqlite3_close(db)
        return []
    }
        
    let resultPointer = UnsafeMutablePointer<Result>.allocate(capacity: 1)
    var result = Result()
    resultPointer.initialize(from: &result, count: 1)
    
    resultcode = sqlite3_exec(
        db,  // database 
        sql, // statement
        {    // callback: non-capturing closure
            resultVoidPointer, columnCount, values, columns in
            let resultPointer = UnsafeMutablePointer<Result>(resultVoidPointer)
            let result = resultPointer.pointee
            
            let row = Result.Row()
            for i in 0 ..< Int(columnCount) {
                guard let value = String(validatingUTF8: values[i]) else {
                    print("No value")
                    continue
                }
                
                guard let column = String(validatingUTF8: columns[i]) else {
                    print("No column")
                    continue
                }
                
                row.data[column] = value
            }
            
            result.rows.append(row)
            return 0
        }, 
        resultPointer, // 
        &errorMessage
    )
    
    if resultcode != SQLITE_OK {
        let errorMsg = String(cString: errorMessage!) ?? ""
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(errorMessage)
    }
    
    sqlite3_close(db)
    return result.rows
}
