//
//  ExampleDatabase.swift
//  SQLite-couchbase-bugg
//
//  Created by Erik Nylander on 2024-12-05.
//

import Foundation

struct Payload: Codable {
    let name: String
    let age: Int
}

class SQLiteDB {
    
    private(set) var db: Database?
    private let _applicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
    private let encoder = JSONEncoder()
    
    func openDatabase() throws {
        if !FileManager.default.fileExists(atPath: _applicationSupportDirectory.path) {
            try FileManager.default.createDirectory(atPath: _applicationSupportDirectory.path,
                    withIntermediateDirectories: true,
                    attributes: nil)

        }
        let dbURL = _applicationSupportDirectory.appending(path: "database.sqlite").path
        print("Database location: \(dbURL)")
        self.db = try Database(storageLocation: .onDisk(dbURL),
                               multiThreaded: true,
                               sharedCache: false
        )
        
        try createTable()
    }
    
    private func createTable() throws {
        guard let db else { fatalError() }
        try db.executeWrite { connection in
            
            let sql = """
PRAGMA journal_mode = WAL;
BEGIN IMMEDIATE TRANSACTION;
CREATE TABLE IF NOT EXISTS documents(
    id INTEGER PRIMARY KEY NOT NULL,
    payload JSON DEFAULT NULL
);
COMMIT TRANSACTION;
"""
            
            try connection.execute(sql)
        }
    }
    
    func truncateTable() throws {
        guard let db else { fatalError() }
        let deleteFromSql = "DELETE FROM documents"
        
        try db.executeWrite { connection in
            try connection.run(deleteFromSql)
        }
    }
    
    func insert(payload: Payload) throws {
        guard let db else { fatalError() }
        let json = String(decoding: try encoder.encode(payload), as: UTF8.self)
        try db.executeWrite { connection in
            
            try connection
                .run(
        """
        INSERT INTO documents(payload)
        VALUES(:payload)
        """,
        [":payload": json])
        }
    }
    
    func jsonExtract() throws {
        guard let db else { fatalError() }
        
        try db.executeRead { connection in
            let sql = """
    SELECT json_extract(payload, "$.name") AS payload_name FROM documents
"""
            // Here we expect ["William", "John"]
            let names: [String] = try connection.query(sql)
            print("json_extract result: \(names)")
        }
    }
    
}
