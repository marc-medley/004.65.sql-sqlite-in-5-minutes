//
//  _main.swift
//  SQLiteIn5WithStatement
//
//  Created by marc on 2016.06.04.
//  Copyright © 2016 --marc. All rights reserved.
//

@main
public struct _main {
    public static func main() {
        let examples = Examples()
        examples.readWithCallbackBasic()
        examples.readWithClosureBasic()
        examples.readWithClosureResults()
        examples.readWithDetails()
        examples.readWithSqlQuery()
    }
}
