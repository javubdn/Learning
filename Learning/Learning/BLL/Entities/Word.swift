//
//  Word.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import Foundation

class Word {
    let id: String
    let initialWord: String
    let endWord: String

    init(id: String, initialWord: String, endWord: String) {
        self.id = id
        self.initialWord = initialWord
        self.endWord = endWord
    }

    func exists() -> Bool {
        guard let tables = getTables() else {
            return false
        }
        let tableNameInit = tables[0]
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryInit = "select * from \(tableNameInit)"
        let wordInit = dbManager.query(queryInit)
        var items = [String]()
        if let itemInit = wordInit as? [[String]]{
            for index in 0..<itemInit.count {
                items.append(itemInit[index][1])
            }
        }
        if items.first(where: { $0 == initialWord }) != nil {
            return true
        }
        return false
    }

    func getAddQueries() -> [String] {
        preconditionFailure("This method must be overridden")
    }

    func getRemoveQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let querySustInit = "delete from \(tableNameInit) where id = '\(id)'"
        let querySustEnd = "delete from \(tableNameEnd)  where id = '\(id)'"
        return [querySustInit, querySustEnd]
    }

    func getUpdateQueries() -> [String] {
        preconditionFailure("This method must be overridden")
    }

    func getTables() -> [String]? {
        return nil
    }
    
}
