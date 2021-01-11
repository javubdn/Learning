//
//  InitGameViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 10/01/2021.
//

import UIKit

class InitGameViewController: UIViewController {

    private var initLanguageSelected = 0
    private var endLanguageSelected = 0

    @IBOutlet weak var initLanguageSelector: ItemSelector!
    @IBOutlet weak var endLanguageSelector: ItemSelector!
    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        title = "Elige juego"
        tabBarItem.title = "Juego"

        let dbManager = DBManager(with: "wordsdb.sql")
        var languages = [String]()
        if let availableLanguages = dbManager.query("select * from languages") {
            for availableLanguage in availableLanguages {
                if let availableLanguage = availableLanguage as? [String] {
                    languages.append(availableLanguage[1])
                }
            }
        }

        initLanguageSelector.listItems = languages
        initLanguageSelector.itemId = .initial
        initLanguageSelector.delegate = self
        endLanguageSelector.listItems = languages
        endLanguageSelector.itemId = .final
        endLanguageSelector.delegate = self
        endLanguageSelector.currentIndex = 1
    }

    //MARK: - Actions

    @IBAction func playButtonPressed(_ sender: UIButton) {

    }

}

extension InitGameViewController: ItemSelectorDelegate {

    func valueChanged(_ selector: ItemSelector) {
        switch selector.itemId {
        case .initial:
            initLanguageSelected = selector.currentIndex
            if initLanguageSelected == endLanguageSelected {
                if selector.currentIndex == 0 {
                    endLanguageSelector.currentIndex = 1
                    endLanguageSelected = 1
                } else {
                    endLanguageSelector.currentIndex = 0
                    endLanguageSelected = 0
                }
            }
        case .final:
            endLanguageSelected = selector.currentIndex
            if initLanguageSelected == endLanguageSelected {
                if selector.currentIndex == 0 {
                    initLanguageSelector.currentIndex = 1
                    initLanguageSelected = 1
                } else {
                    initLanguageSelector.currentIndex = 0
                    initLanguageSelected = 0
                }
            }
        case .none:
            break
        }

    }

}
