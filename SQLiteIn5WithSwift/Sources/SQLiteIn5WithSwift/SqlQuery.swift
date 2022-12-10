//
//  SqlQuery.swift
//  SQLiteIn5WithSwift
//
//  Created by marc on 2016.06.05.
//  Copyright © 2016 --marc. All rights reserved.
//

import Foundation
import SQLite3

// defines not currently imported to Swift from <sqlite3.h>
//#define SQLITE_STATIC      ((sqlite3_destructor_type)0)
//#define SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1)                 
// SQLITE_STATIC static, unmanaged value. not freed by SQLite.
internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
// SQLITE_TRANSIENT volatile value. SQLite makes private copy before returning.
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class SqlQuery {
    var db: OpaquePointer? = nil
    var statement: OpaquePointer? = nil // statement byte code
    
    init(db: OpaquePointer) {
        self.db = db
    }
    
    init(path: String) {
        _ = databaseOpen(path: path)
    }
    
    deinit {
        if db != nil {
            // release to statement object to avoid memory leaks
            // sqlite3_finalize destroy a prepared statement object
            // sqlite3_finalize(sqlite3_stmt *pStmt);
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            // Close Database
            let result: Int32 = sqlite3_close_v2(db)
            if result != SQLITE_OK {
                print(":ERROR: SqlQuery `deinit` sqlite3_close result: \(result)")

            }
        }
    }
    
    /// - parameter path: /path/to/database.sqlitedb
    func databaseOpen(path: String) -> Int32 {
        if let cFileName = path.cString(using: String.Encoding.utf8) {
            let openMode: Int32 = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
            let statusOpen = sqlite3_open_v2(
                cFileName, // filename: UnsafePointer<CChar> … UnsafePointer<Int8>
                &db,       // ppDb: UnsafeMutablePointer<OpaquePointer?> aka handle
                openMode,  // flags: Int32 
                nil        // zVfs VFS module name: UnsafePointer<CChar> … UnsafePointer<Int8>
            )
            if statusOpen != SQLITE_OK {
                print("error opening database")
            }
            return statusOpen
        }
        return 1
    }
    
    func databaseClose() {
        // release to statement object to avoid memory leaks
        // sqlite3_finalize destroy a prepared statement object
        // sqlite3_finalize(sqlite3_stmt *pStmt);
        if db != nil {
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }

            // Close Database
            let result: Int32 = sqlite3_close_v2(db)
            if result != SQLITE_OK {
                print(":ERROR: databaseClose() result \(result)")
            } else {
                db = nil
            }
        }
    }
    
    func statementPrepare(_ sql: String) -> Int32 {
        if let cSql = sql.cString(using: String.Encoding.utf8) {
            let statusPrepare = sqlite3_prepare_v2(
                db,         // sqlite3 *db          : Database handle
                cSql,       // const char *zSql     : SQL statement, UTF-8 encoded
                -1,         // int nByte            : -1 to first zero terminator | zSql max bytes
                &statement, // qlite3_stmt **ppStmt : OUT: Statement byte code handle
                nil         // const char **pzTail  : OUT: unused zSql pointer
            ) 
            if statusPrepare != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing compiled statement: \(errmsg)")
            }
            return statusPrepare
        }
        return 1
    }
    
    func statementReset() {
        sqlite3_reset(statement)
    }
    
    func statementBind(paramIndex: Int32, paramValue: String) -> Int32 {
        if let cParamValue = paramValue.cString(using: String.Encoding.utf8) {
            let statusBind = sqlite3_bind_text(
                statement,        // sqlite3_stmt*  : statement from sqlite3_prepare_v2()
                paramIndex,       // int            : parameter index to set. starts @ 1
                cParamValue,      // const char*    : parameter value to bind
                -1,               // int            : -1 is NUL terminated | value byte count
                SQLITE_TRANSIENT  // void(*)(void*) : SQLITE_TRANSIENT: SQLite makes private copy
            )
            if statusBind != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure binding \(paramValue): \(errmsg)")
            }
            return statusBind
        }
        return 1
    }
    
    func statementExecute() {
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
                    if let v = sqlite3_column_text(statement, i) {
                        let s = String(cString: v)
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
    }
    
}
