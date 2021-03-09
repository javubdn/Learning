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

    func getAddQueries(into tables: [String]) -> [String] {
        preconditionFailure("This method must be overridden")
    }
}
