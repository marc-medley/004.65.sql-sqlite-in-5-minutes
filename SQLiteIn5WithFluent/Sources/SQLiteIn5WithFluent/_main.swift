

import Foundation // also imported in Fluent, FluentKit, FluentSQLiteDriver
//import Fluent             // FluentKit, NIOCore, SwiftOnoneSupport, Vapor
//import FluentKit // AsyncKit, Darwin, Logging, NIO, NIOConcurrencyHelpers, NIOCore, SwiftOnoneSupport
import FluentSQLiteDriver // FluentKit, FluentSQL, NIO, SQLiteKit, SwiftOnoneSupport

//struct TryMe: Migration, Model {
//    var name: String? // Migration 
//    var id: UUID?     // Model
//    
//    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
//        fatalError()
//    }
//    
//    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
//        fatalError()
//    }
//    
//}

@main
public struct _main {

    //app.databases.use(<db config>, as: <identifier>)
    
    public private(set) var text = "SQLiteIn5WithFluent"
    
    var db: Database!
    
    
    public static func main() {
        print(_main().text)
        
        
        // FLite.memory.prepare(migration: Migration) -> EventLoopFuture<Void>
        //let b: EventLoopFuture<Void> = FLite.memory.prepare(migration: Migration)
        
        // FLite.memory.prepare(migration: (Migration & Model).Protocol) -> EventLoopFuture<Void>
        try? FLite.memory.prepare(migration: Todo.self).wait()
        
        try! FLite.memory.add(model: Todo(title: "Task 1", strings: ["make bed", "fold clothes"])).wait()
        try! FLite.memory.add(model: Todo(title: "Task: Run Errands")).wait()
        
        FLite.memory.all(model: Todo.self)
            .whenSuccess {
                // callback: ([Todo]) -> Void
                (todos: [Todo]) in
                print(todos)
            }
        
        //FLite.memory.all(model: Todo.self)
        //    .whenSuccessBlocking(onto: <#T##DispatchQueue#>, <#T##callbackMayBlock: ([Todo]) -> Void##([Todo]) -> Void#>)
        
        // ----- FLite Instance -----
        let persist = FLite(configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/SQLiteIn5WithFluent.sqlite"), loggerLabel: "persisted-FLITE")

        try? persist.prepare(migration: Todo.self).wait()

        try! persist.add(model: Todo(title: "Hello World", strings: ["hello", "world"])).wait()

        persist.all(model: Todo.self)
            .whenSuccess { (values) in
                print(values)
        }
    }
    
}
