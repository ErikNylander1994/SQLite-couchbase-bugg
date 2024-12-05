//
//  SQLite_couchbase_buggApp.swift
//  SQLite-couchbase-bugg
//
//  Created by Erik Nylander on 2024-12-05.
//

import SwiftUI

@main
struct SQLite_couchbase_buggApp: App {
    
    private let payload_a = Payload(name: "William", age: 30)
    private let payload_b = Payload(name: "John", age: 44)
    
    init() {
        do {
            let db = SQLiteDB()
            try db.openDatabase()
            try db.truncateTable()
            try db.insert(payload: payload_a)
            try db.insert(payload: payload_b)
            // Does not work when CouchbaseLiteSwift is included in target's "Link Binary With Libraries"
            try db.jsonExtract()
        } catch {
            print("Error from SQLite: \(String(describing: error))")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
