//
//  CurrentWordViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 12/01/2021.
//

import UIKit

class CurrentWordViewController: UIViewController {

    private var languages: [String] = []

    @IBOutlet weak var typeItemSelector: ItemSelector!
    @IBOutlet weak var sustantiveView: UIView!
    @IBOutlet weak var verbView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScreen()
    }

    private func prepareScreen() {
        typeItemSelector.listItems = ["Sustantivo", "Verbo"]
        typeItemSelector.itemId = .initial
        typeItemSelector.delegate = self

        let dbManager = DBManager(with: "wordsdb.sql")
        if let availableLanguages = dbManager.query("select * from languages") {
            for availableLanguage in availableLanguages {
                if let availableLanguage = availableLanguage as? [String] {
                    languages.append(availableLanguage[1])
                }
            }
        }
        prepareSustantiveView()

    }

    private func prepareSustantiveView() {
        for language in languages {
            let languageView = UIView()
            let nameLabel = UILabel()
            nameLabel.text = language
            languageView.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            let labelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[nameLabel]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel])
            let labelVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[nameLabel]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel])

            languageView.addConstraints(labelHorizontalConstraints+labelVerticalConstraints)

            sustantiveView.addSubview(languageView)
            
            languageView.translatesAutoresizingMaskIntoConstraints = false

            let horizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[languageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["languageView": languageView])

            let verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[languageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["languageView": languageView])

            sustantiveView.addConstraints(horizontalConstraints+verticalConstraints)


        }
    }

}

extension CurrentWordViewController: ItemSelectorDelegate {

    func valueChanged(_ selector: ItemSelector) {
        switch selector.itemId {
        case .initial:
            if selector.currentIndex == 0 {
                sustantiveView.isHidden = false
                verbView.isHidden = true
            } else if selector.currentIndex == 1 {
                sustantiveView.isHidden = true
                verbView.isHidden = false
            }
        default:
            break
        }

    }

}
