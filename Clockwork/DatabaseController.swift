//
//  Database.swift
//  Clockwork
//
//  Created by Andrew Li on 1/5/22.
//

import Foundation
import SQLite

struct Entry: Codable {
    let date: Date
    let duration: Int
}

struct EntryWithId: Codable {
    let id: Int
    let date: Date
    let duration: Int
}

class DatabaseController {
    private var db: Connection
    private var days: Table
    var entries: [EntryWithId] {
        try! db.prepare(days).map { try! $0.decode() }
    }
    
    init() throws {
        let fileUrl = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("timesheet.sqlite")
        db = try Connection(fileUrl.path)
        
        days = Table("days")
        let id = Expression<Int>("id")
        let date = Expression<Date>("date")
        let duration = Expression<Int>("duration")
        
        try db.run(days.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(date)
            t.column(duration)
        })
    }
    
    func add(entry: Entry) throws {
        let insert = try days.insert(entry)
        try db.run(insert)
    }
}
