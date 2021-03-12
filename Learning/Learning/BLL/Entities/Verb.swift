//
//  Verb.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import Foundation

class Verb: Word {
    let initialPart: String
    let endPart: String

    init(id: String,initialWord: String, endWord: String, initialPart: String, endPart: String) {
        self.initialPart = initialPart
        self.endPart = endPart
        super.init(id: id, initialWord: initialWord, endWord: endWord)
    }

    override func getAddQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let uuid = UUID().uuidString
        let queryVerbInit = "insert into \(tableNameInit) (id, word, participle) values ('\(uuid)', '\(initialWord)', '\(initialPart)')"
        let queryVerbEnd = "insert into \(tableNameEnd) (id, word, participle) values ('\(uuid)', '\(endWord)', '\(endPart)')"
        return [queryVerbInit, queryVerbEnd]
    }

    override func getUpdateQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let queryVerbInit = "update \(tableNameInit) set word = '\(initialWord)', participle = '\(initialPart)' where id = '\(id)'"
        let queryVerbEnd = "update \(tableNameEnd) set word = '\(endWord)', participle = '\(endPart)' where id = '\(id)'"
        return [queryVerbInit, queryVerbEnd]
    }

    override func getTables() -> [String]? {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryLanguages = "select * from languages"
        guard let availableLanguages = dbManager.query(queryLanguages) else {
            return nil
        }
        guard let initLanguageValue = availableLanguages[0] as? [String],
              let endLanguageValue = availableLanguages[1] as? [String] else {
            return nil
        }
        return [initLanguageValue[3], endLanguageValue[3]]
    }
}
