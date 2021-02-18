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
                let sustantive = Sustantive(initialWord: sustInit[index][1],
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
                let verb = Verb(initialWord: verbInit[index][1],
                                endWord: verbEnd[index][1],
                                initialPart: verbInit[index][2],
                                endPart: verbEnd[index][2])
                listWords.append(verb)
            }
        }

        return listWords
    }
}
