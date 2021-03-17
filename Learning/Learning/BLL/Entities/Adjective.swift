//
//  Adjective.swift
//  Learning
//
//  Created by Javi Castillo Risco on 14/03/2021.
//

import Foundation

class Adjective: Word {

    override func getAddQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let uuid = UUID().uuidString
        let querySustInit = "insert into \(tableNameInit) (id, word) values ('\(uuid)', '\(initialWord)')"
        let querySustEnd = "insert into \(tableNameEnd) (id, word) values ('\(uuid)', '\(endWord)')"
        return [querySustInit, querySustEnd]
    }

    override func getUpdateQueries() -> [String] {
        guard let tables = getTables() else {
            return []
        }
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let querySustInit = "update \(tableNameInit) set word = '\(initialWord)' where id = '\(id)'"
        let querySustEnd = "update \(tableNameEnd) set word = '\(endWord)' where id = '\(id)'"
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
        return [initLanguageValue[4], endLanguageValue[4]]
    }

}
