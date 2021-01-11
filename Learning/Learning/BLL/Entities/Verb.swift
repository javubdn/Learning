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

    init(initialWord: String, endWord: String, initialPart: String, endPart: String) {
        self.initialPart = initialPart
        self.endPart = endPart
        super.init(initialWord: initialWord, endWord: endWord)
    }
}
