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
        var listWords = getSustantives(initLanguageValue: initLanguageValue, endLanguageValue: endLanguageValue)
        listWords.append(contentsOf: getVerbs(initLanguageValue: initLanguageValue, endLanguageValue: endLanguageValue))
        listWords.append(contentsOf: getAdjectives(initLanguageValue: initLanguageValue, endLanguageValue: endLanguageValue))
        listWords.append(contentsOf: getAdverbs(initLanguageValue: initLanguageValue, endLanguageValue: endLanguageValue))
        return listWords
    }

    private func getSustantives(initLanguageValue: [String], endLanguageValue: [String]) -> [Word] {
        let dbManager = DBManager(with: "wordsdb.sql")
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
        return listWords
    }

    private func getVerbs(initLanguageValue: [String], endLanguageValue: [String]) -> [Word] {
        let dbManager = DBManager(with: "wordsdb.sql")
        let queryVerbInit = "select * from \(initLanguageValue[3])"
        let verbInit = dbManager.query(queryVerbInit)
        let queryVerbEnd = "select * from \(endLanguageValue[3])"
        let verbEnd = dbManager.query(queryVerbEnd)
        var listWords = [Word]()
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

    private func getAdjectives(initLanguageValue: [String], endLanguageValue: [String]) -> [Word] {
        let dbManager = DBManager(with: "wordsdb.sql")
        var listWords = [Word]()
        let queryAdjInit = "select * from \(initLanguageValue[4])"
        let adjInit = dbManager.query(queryAdjInit)
        let queryAdjEnd = "select * from \(endLanguageValue[4])"
        let adjEnd = dbManager.query(queryAdjEnd)

        if let adjInit = adjInit as? [[String]],
           let adjEnd = adjEnd as? [[String]] {
            for index in 0..<adjInit.count {
                let adjective = Adjective(id: adjInit[index][0], initialWord: adjInit[index][1], endWord: adjEnd[index][1])
                listWords.append(adjective)
            }
        }
        return listWords
    }

    private func getAdverbs(initLanguageValue: [String], endLanguageValue: [String]) -> [Word] {
        let dbManager = DBManager(with: "wordsdb.sql")
        var listWords = [Word]()
        let queryAdvInit = "select * from \(initLanguageValue[5])"
        let advInit = dbManager.query(queryAdvInit)
        let queryAdvEnd = "select * from \(endLanguageValue[5])"
        let advEnd = dbManager.query(queryAdvEnd)

        if let advInit = advInit as? [[String]],
           let advEnd = advEnd as? [[String]] {
            for index in 0..<advInit.count {
                let adverb = Adverb(id: advInit[index][0], initialWord: advInit[index][1], endWord: advEnd[index][1])
                listWords.append(adverb)
            }
        }
        return listWords
    }

    func addWord(_ word: Word) -> APIError? {
        let dbManager = DBManager(with: "wordsdb.sql")
        for query in word.getAddQueries() {
            let success = dbManager.execute(query)
            if !success {
                return .failInDB
            }
        }
        return nil
    }

    func removeWord(_ word: Word) -> APIError?  {
        let dbManager = DBManager(with: "wordsdb.sql")
        for query in word.getRemoveQueries() {
            let success = dbManager.execute(query)
            if !success {
                return .failInDB
            }
        }
        return nil
    }

    func updateWord(_ word: Word) -> APIError?  {
        let dbManager = DBManager(with: "wordsdb.sql")
        for query in word.getUpdateQueries() {
            let success = dbManager.execute(query)
            if !success {
                return .failInDB
            }
        }
        return nil
    }

}
