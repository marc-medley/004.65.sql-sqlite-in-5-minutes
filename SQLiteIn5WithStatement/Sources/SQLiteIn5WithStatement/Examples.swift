//
//  Examples.swift
//  
//
//  Created by mc on 2022.12.09.
//

import Foundation

struct Examples {
    //let filename = ":memory:"           // creates temporary database in memory
    let filename = "example.sqlitedb" // creates database with filename on disk
    
    init() {
        setup()
    }
    
    /// Setup using `sqlCommand`
    func setup() {
        // SETUP DATABASE BEGINS ... exec non-callback commands open, create table & insert data
        var argv = [
            "sqlCommand", 
            filename, 
            "DROP TABLE IF EXISTS people;"
        ]
        _ = sqlCommand(argc: argv.count, argv: argv)

        argv = [
            "sqlCommand", 
            filename, 
            "CREATE TABLE people (name TEXT, date_of_birth DATETIME, tickets INTEGER, balance REAL);"
        ]
        _ = sqlCommand(argc: argv.count, argv: argv)

        argv = [
            "sqlCommand", 
            filename, 
            "INSERT INTO people VALUES ('Jay', '1977-01-01', 0, 0);"
        ]
        _ = sqlCommand(argc: argv.count, argv: argv)

        argv = ["sqlCommand", 
                filename, 
                "INSERT INTO people VALUES ('Kay', '1988-05-09', 1, 10.00);"]
        _ = sqlCommand(argc: argv.count, argv: argv)

        _ = sqlCommand(
            path: filename, 
            sql: "INSERT INTO people VALUES ('Zay', '2000-01-01', 2, 55.23);"
        )
        // SETUP DATABASE COMPLETE.
    }
    
    func readWithCallbackBasic() {
        // EXAMPLE CallbackBasic.swift: Basic C-Style Callback
        print(":: Query Database, Basic Callback ::")
        let argv = ["sqlQueryCallbackBasic", 
                filename, 
                "SELECT * FROM people;"]
        _ = sqlQueryCallbackBasic(argc: argv.count, argv: argv)
    }
    
    func readWithClosureBasic() {
        // EXAMPLE ClosureBasic.swift: Basic Closure
        let argv = ["sqlQueryCallbackBasic", 
                filename, 
                "SELECT * FROM people;"]
        print("\n:: Query Database, Basic Closure ::")
        _ = sqlQueryClosureBasic(argc: argv.count, argv: argv)
    }
    
    func readWithClosureResults() {
        // EXAMPLE: ClosureResults.swift: Closure with 
        print("\n:: Query Database, Closure with Results Array ::")
        let results = sqlQueryClosureWithResults(
            path: filename, 
            sql: "SELECT * FROM people;"
        )
        print(":: Results Array ::")
        for r in results {
            print(r.data)
        }
    }
    
    func readWithDetails() {
        // EXAMPLE: Details.swift: Closure with prepare, step, column, and finalize
        print("\n:: Query Database. Details prepare, step, column, and finalize ::")
        sqlQueryDetails(
            path: filename, 
            sql: "SELECT * FROM people;"
        )
    }
    
    func readWithSqlQuery() {
        // EXAMPLE: SqlQuery.swift: Closure with prepare, step, column, and finalize
        print("\n:: SqlQuery.swift. Prepare, bind, step, column, and finalize ::")
        let sqlQuery = SqlQuery(path: filename)
        _ = sqlQuery.statementPrepare("SELECT * FROM people WHERE name = :1;")
        _ = sqlQuery.statementBind(paramIndex: 1, paramValue: "Kay")
        sqlQuery.statementExecute()
        
        print(":BEGIN: _Sample sqlQuery.databaseClose()")
        sqlQuery.databaseClose()
        print(":END: _Sample sqlQuery.databaseClose()")
    }
}
