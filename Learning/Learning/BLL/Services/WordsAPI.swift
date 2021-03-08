//
//  WordsAPI.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import Foundation

class WordsAPI {

    func getListWords(initLanguage: Int, endLanguage: Int) -> [Word]? {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryLanguages = "select * from languages"
        guard let availableLanguages = dbManager.query(queryLanguages) else {
            return nil
        }
        guard let initLanguageValue = availableLanguages[initLanguage] as? [String],
              let endLanguageValue = availableLanguages[endLanguage] as? [String] else {
            return nil
        }
        var listWords = [Word]()
        let querySustInit = "select * from \(initLanguageValue[2])"
        let sustInit = dbManager.query(querySustInit)
        let querySustEnd = "select * from \(endLanguageValue[2])"
        let sustEnd = dbManager.query(querySustEnd)

        if let sustInit = sustInit as? [[String]],
           let sustEnd = sustEnd as? [[String]] {
            for index in 0..<sustInit.count {
                let sustantive = Sustantive(id: sustInit[index][0],
                                            initialWord: sustInit[index][1],
                                            endWord: sustEnd[index][1],
                                            initialGenre: sustInit[index][2],
                                            endGenre: sustEnd[index][2],
                                            initialPlural: sustInit[index][3],
                                            endPlural: sustEnd[index][3])
                listWords.append(sustantive)
            }
        }

        let queryVerbInit = "select * from \(initLanguageValue[3])"
        let verbInit = dbManager.query(queryVerbInit)
        let queryVerbEnd = "select * from \(endLanguageValue[3])"
        let verbEnd = dbManager.query(queryVerbEnd)

        if let verbInit = verbInit as? [[String]],
           let verbEnd = verbEnd as? [[String]] {
            for index in 0..<verbInit.count {
                let verb = Verb(id: verbInit[index][0],
                                initialWord: verbInit[index][1],
                                endWord: verbEnd[index][1],
                                initialPart: verbInit[index][2],
                                endPart: verbEnd[index][2])
                listWords.append(verb)
            }
        }

        return listWords
    }

    func addWord(_ word: Word) {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryLanguages = "select * from languages"
        guard let availableLanguages = dbManager.query(queryLanguages) else {
            return
        }
        guard let initLanguageValue = availableLanguages[0] as? [String],
              let endLanguageValue = availableLanguages[1] as? [String] else {
            return
        }

        if let sustantive = word as? Sustantive {
            let tableNameInit = initLanguageValue[2]
            let tableNameEnd = endLanguageValue[2]
            let uuid = UUID().uuidString
            let querySustInit = "insert into \(tableNameInit) (id, word, genre, plural) values ('\(uuid)', '\(sustantive.initialWord)', '\(sustantive.initialGenre)', '\(sustantive.initialPlural)')"
            let querySustEnd = "insert into \(tableNameEnd) (id, word, genre, plural) values ('\(uuid)', '\(sustantive.endWord)', '\(sustantive.endGenre)', '\(sustantive.endPlural)')"
            dbManager.execute(querySustInit)
            dbManager.execute(querySustEnd)
        } else if let verb = word as? Verb {
            let tableNameInit = initLanguageValue[3]
            let tableNameEnd = endLanguageValue[3]
            let uuid = UUID().uuidString
            let queryVerbInit = "insert into \(tableNameInit) (id, word, participle) values ('\(uuid)', '\(verb.initialWord)', '\(verb.initialPart)')"
            let queryVerbEnd = "insert into \(tableNameEnd) (id, word, participle) values ('\(uuid)', '\(verb.endWord)', '\(verb.endPart)')"
            dbManager.execute(queryVerbInit)
            dbManager.execute(queryVerbEnd)
        }
        
    }

    func removeWord(_ word: Word) {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryLanguages = "select * from languages"
        guard let availableLanguages = dbManager.query(queryLanguages) else {
            return
        }
        guard let initLanguageValue = availableLanguages[0] as? [String],
              let endLanguageValue = availableLanguages[1] as? [String] else {
            return
        }

        if let sustantive = word as? Sustantive {
            let tableNameInit = initLanguageValue[2]
            let tableNameEnd = endLanguageValue[2]
            let querySustInit = "delete from \(tableNameInit) where id = '\(sustantive.id)'"
            let querySustEnd = "delete from \(tableNameEnd)  where id = '\(sustantive.id)'"
            dbManager.execute(querySustInit)
            dbManager.execute(querySustEnd)
        } else if let verb = word as? Verb {
            let tableNameInit = initLanguageValue[3]
            let tableNameEnd = endLanguageValue[3]
            let queryVerbInit = "delete from \(tableNameInit) where id = '\(verb.id)'"
            let queryVerbEnd = "delete from \(tableNameEnd) where id = '\(verb.id)'"
            dbManager.execute(queryVerbInit)
            dbManager.execute(queryVerbEnd)
        }
    }

    func updateWord(_ word: Word) {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryLanguages = "select * from languages"
        guard let availableLanguages = dbManager.query(queryLanguages) else {
            return
        }
        guard let initLanguageValue = availableLanguages[0] as? [String],
              let endLanguageValue = availableLanguages[1] as? [String] else {
            return
        }
        if let sustantive = word as? Sustantive {
            let tableNameInit = initLanguageValue[2]
            let tableNameEnd = endLanguageValue[2]
            let querySustInit = "update \(tableNameInit) set word = '\(sustantive.initialWord)', genre = '\(sustantive.initialGenre)', plural = '\(sustantive.initialPlural)' where id = '\(sustantive.id)'"
            let querySustEnd = "update \(tableNameEnd) set word = '\(sustantive.endWord)', genre = '\(sustantive.endGenre)', plural = '\(sustantive.endPlural)' where id = '\(sustantive.id)'"
            dbManager.execute(querySustInit)
            dbManager.execute(querySustEnd)
        } else if let verb = word as? Verb {
            let tableNameInit = initLanguageValue[3]
            let tableNameEnd = endLanguageValue[3]
            let queryVerbInit = "update \(tableNameInit) set word = '\(verb.initialWord)', participle = '\(verb.initialPart)' where id = '\(verb.id)'"
            let queryVerbEnd = "update \(tableNameEnd) set word = '\(verb.endWord)', participle = '\(verb.endPart)' where id = '\(verb.id)'"
            dbManager.execute(queryVerbInit)
            dbManager.execute(queryVerbEnd)
        }
    }

}
