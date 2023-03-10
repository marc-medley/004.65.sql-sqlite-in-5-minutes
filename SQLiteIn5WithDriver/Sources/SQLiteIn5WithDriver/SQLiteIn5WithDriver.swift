import Foundation
import FluentBenchmark
// imports FluentKit, FluentSQL, Foundation, NIO, SQLiteKit, SwiftOnoneSupport
import FluentSQLiteDriver

// See https://github.com/m-housh/swift-web-utils/blob/baba1dab13a95b2312b7eee79f29c21fbf9b3f75/Tests/DatabaseUtilsTests/TestHelpers.swift 

@main
public struct SQLiteIn5WithDriver {
    public static func main() {
        var o = SQLiteIn5WithDriver()
        o.printCoreCounts()
        o.doit()
    }
    
    var eventLoopGroup: EventLoopGroup!
    var threadPool: NIOThreadPool!
    var connection: SQLiteConnection!
    
    mutating func doit() {
        // --- configuration ---
        // SQLiteConfiguration.init(storage: .file(path: "FINDME_db.sqlite"), enableForeignKeys: false)
        let config = SQLiteConfiguration(
            storage: .memory(identifier: "ramdb"), 
            enableForeignKeys: false)
        
        threadPool = NIOThreadPool(numberOfThreads: 1)
        let source = SQLiteConnectionSource(
            configuration: config, 
            threadPool: threadPool) // NIOThreadPool
        
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        connection = try! source.makeConnection(
            logger: .init(label: "test"), // Logger
            on: eventLoopGroup.next()) // EventLoop
            .wait()
        
        let sql: SQLDatabase = connection.sql()
        
        do {
            try sql.raw("CREATE TABLE foo (name TEXT UNIQUE)").run().wait()
            try sql.raw("INSERT INTO foo (name) VALUES ('bar')").run().wait()
        } catch {
            print("sql error: \(error)")
        }
        
        try! connection.close().wait()
        connection = nil
        try! self.threadPool.syncShutdownGracefully()
        threadPool = nil
        try! self.eventLoopGroup.syncShutdownGracefully()
        eventLoopGroup = nil
    }
    
    func printCoreCounts() {
        // //sysctl -n hw.ncpu
        //ProcessInfo.processInfo.processorCount
        // //sysctl -n hw.logicalcpu
        //ProcessInfo.processInfo.activeProcessorCount 

        print("""
            printCoreCounts:
                  processorCount = \(ProcessInfo.processInfo.processorCount)
            activeProcessorCount = \(ProcessInfo.processInfo.activeProcessorCount)
              physicalCoresCount = \(physicalCoresCount())
        """)
    }
    
    func physicalCoresCount() -> UInt {
        var size: size_t = MemoryLayout<UInt>.size
        var coresCount: UInt = 0
        sysctlbyname("hw.physicalcpu", &coresCount, &size, nil, 0)
        return coresCount
    }
    
    fileprivate func makeSQLiteURL() -> String {
        guard var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError()
        }

        url = url.appendingPathComponent("db")

        if FileManager.default.fileExists(atPath: url.path) {
            var excludedFromBackup = URLResourceValues()
            excludedFromBackup.isExcludedFromBackup = true
            try! url.setResourceValues(excludedFromBackup)
        }

        return url.path
    }
}


