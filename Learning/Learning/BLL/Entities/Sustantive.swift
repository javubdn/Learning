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

    init(initialWord: String, endWord: String, initialGenre: String, endGenre: String) {
        self.initialGenre = initialGenre
        self.endGenre = endGenre
        super.init(initialWord: initialWord, endWord: endWord)
    }
}
