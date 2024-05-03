//
//  DBHelpers.swift
//  Doll-Coloring
//
//  Created by Lê Minh Sơn on 18/02/2024.
//

import Foundation
import SQLite

class DBHelpers {
    static let shared = DBHelpers()
    
    private let rmvbgHistoryTB = Table("rmvbg-history-table")
    private let DB_VERSION = 1
    
    init() {
        createRMVBGTable()
    }
    
    var database: Connection? {
        do {
            let path2DB = NSHomeDirectory().appending("/Documents/rmvbg-db")
            let db = try Connection(path2DB)
            db.userVersion = UserVersion(DB_VERSION)
            return db
        } catch {
            print("Database::Open database failed: \(error)")
            return nil
        }
    }
    
    private func createRMVBGTable() {
        do {
            _ = try database?.run(rmvbgHistoryTB.create(ifNotExists: true) { table in
                
            })
        } catch(let error) {
            print("Database::createReminderTable failed: \(error)")
        }
    }
}
