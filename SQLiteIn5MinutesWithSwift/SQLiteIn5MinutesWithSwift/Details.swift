//
//  Details.swift
//  SQLiteIn5MinutesWithSwift
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation

/**
 
 - Note: Uses `sqlite3_prepare()`, `sqlite3_step()`, `sqlite3_column()`, and `sqlite3_finalize() instead of the `sqlite3_exec` convenience wrapper.
 
 */
func sqlQueryDetails(path: String, sql: String) {
    var db: OpaquePointer? = nil
    var statement: OpaquePointer? = nil // statement byte code
    
    // Open Database
    if let cFileName = path.cString(using: String.Encoding.utf8) {
        let openMode: Int32 = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        let statusOpen = sqlite3_open_v2(
            cFileName, // filename: UnsafePointer<CChar> 
            &db,       // ppDb: UnsafeMutablePointer<COpaquePointer> aka handle
            openMode,  // flags: Int32 
            nil        // zVfs VFS module name: UnsafePointer<Int8>
        )
        if statusOpen != SQLITE_OK {
            print("error opening database")
            return
        }
    }
    
    
    // A: Prepare SQL Statement. Compile SQL text to byte code object.
    let statusPrepare = sqlite3_prepare_v2(
        db,         // sqlite3 *db          : Database handle
        sql,        // const char *zSql     : SQL statement, UTF-8 encoded
        -1,         // int nByte            : -1 to first zero terminator | zSql max bytes
        &statement, // qlite3_stmt **ppStmt : OUT: Statement byte code handle
        nil         // const char **pzTail  : OUT: unused zSql pointer
    ) 
    if statusPrepare != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db))
        print("error preparing compiled statement: \(errmsg)")
        return
    }
        
    // B: Bind. This example does not bind any parameters
        
    // C: Column Step.  Interate through columns.
    var statusStep = sqlite3_step(statement)
    while statusStep == SQLITE_ROW {
        
        print("-- ROW --")
        for i in 0 ..< sqlite3_column_count(statement) { 
            let cp = sqlite3_column_name(statement, i)
            let columnName = String(cString: cp!)

            switch sqlite3_column_type(statement, i) {
            case SQLITE_BLOB:
                print("SQLITE_BLOB:    \(columnName)")
            case SQLITE_FLOAT:  
                let v: Double = sqlite3_column_double(statement, i)
                print("SQLITE_FLOAT:   \(columnName)=\(v)")
            case SQLITE_INTEGER:
                // let v:Int32 = sqlite3_column_int(statement, i)
                let v: Int64 = sqlite3_column_int64(statement, i)
                print("SQLITE_INTEGER: \(columnName)=\(v)")
            case SQLITE_NULL:  
                print("SQLITE_NULL:    \(columnName)")
            case SQLITE_TEXT: // SQLITE3_TEXT
                let v = sqlite3_column_text(statement, i)
                if v != nil {
                    let s = String(cString: CCharPointer(v!))
                    print("SQLITE_TEXT:    \(columnName)=\(s)")
                } 
                else {
                    print("SQLITE_TEXT: not convertable")
                }            
            default:
                print("sqlite3_column_type not found")
                break
            }
        }
        
        // next step
        statusStep = sqlite3_step(statement)
    }
    if statusStep != SQLITE_DONE {
        let errmsg = String(cString: sqlite3_errmsg(db))
        print("failure inserting foo: \(errmsg)")
    }
    

    
    // D. Deallocate. Release statement object.
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db))
        print("error finalizing prepared statement: \(errmsg)")
    }
    
    // Close Database
    if sqlite3_close_v2(db) != SQLITE_OK {
        print("error closing database")
    }

}
