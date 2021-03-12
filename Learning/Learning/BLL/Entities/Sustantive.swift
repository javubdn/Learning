//
//  Sustantive.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import Foundation

class Sustantive: Word {
    let initialGenre: String
    let endGenre: String
    let initialPlural: String
    let endPlural: String

    init(id: String, initialWord: String, endWord: String, initialGenre: String, endGenre: String, initialPlural: String, endPlural: String) {
        self.initialGenre = initialGenre
        self.endGenre = endGenre
        self.initialPlural = initialPlural
        self.endPlural = endPlural
        super.init(id: id, initialWord: initialWord, endWord: endWord)
    }

    override func getAddQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let uuid = UUID().uuidString
        let querySustInit = "insert into \(tableNameInit) (id, word, genre, plural) values ('\(uuid)', '\(initialWord)', '\(initialGenre)', '\(initialPlural)')"
        let querySustEnd = "insert into \(tableNameEnd) (id, word, genre, plural) values ('\(uuid)', '\(endWord)', '\(endGenre)', '\(endPlural)')"
        return [querySustInit, querySustEnd]
    }

    override func getUpdateQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let querySustInit = "update \(tableNameInit) set word = '\(initialWord)', genre = '\(initialGenre)', plural = '\(initialPlural)' where id = '\(id)'"
        let querySustEnd = "update \(tableNameEnd) set word = '\(endWord)', genre = '\(endGenre)', plural = '\(endPlural)' where id = '\(id)'"
        return [querySustInit, querySustEnd]
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
        return [initLanguageValue[2], endLanguageValue[2]]
    }

}
