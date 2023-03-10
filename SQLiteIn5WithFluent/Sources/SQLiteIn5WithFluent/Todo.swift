//
//  Todo.swift
//  
//
//  Created by mc on 2022.12.11.
//

import Foundation
//import FluentKit
import FluentSQLiteDriver

// :WAS: `Identifiable`, `Codable`
// :???: `Content` is `Codable`, `RequestDecodable`, `ResponseEncodable` via `Vapor`
final class Todo: Model, Codable {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "strings")
    var strings: [String]?
    
    init() { }
    
    init(id: UUID? = nil, title: String, strings: [String]? = nil) {
        self.id = id
        self.title = title
        self.strings = strings
    }
}

extension Todo: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("strings", .array(of: .string))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("todos").delete()
    }
}

struct CreateTodo: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("todos")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("todos").delete()
    }
}

struct CreateTodoAsync: AsyncMigration {
    // AsyncMigration
    func prepare(on database: Database) async throws {
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}

