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

    override func getAddQueries(into tables: [String]) -> [String] {
        let tableNameInit = tables[0]
        let tableNameEnd = tables[1]
        let uuid = UUID().uuidString
        let querySustInit = "insert into \(tableNameInit) (id, word, genre, plural) values ('\(uuid)', '\(initialWord)', '\(initialGenre)', '\(initialPlural)')"
        let querySustEnd = "insert into \(tableNameEnd) (id, word, genre, plural) values ('\(uuid)', '\(endWord)', '\(endGenre)', '\(endPlural)')"
        return [querySustInit, querySustEnd]
    }

}
