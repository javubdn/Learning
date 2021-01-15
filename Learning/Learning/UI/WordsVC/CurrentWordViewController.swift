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
        var previewView: UIView?
        for language in languages {
            let languageView = UIView()
            let nameLabel = UILabel()
            nameLabel.text = "Palabra en \(language)"
            languageView.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            let nameLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[nameLabel]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel])
            let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[nameLabel(30)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel])

            let nameTextField = UITextField()
            nameTextField.borderStyle = .roundedRect
            languageView.addSubview(nameTextField)
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            let nameTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[nameLabel]-20-[nameTextField(100)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel, "nameTextField": nameTextField])
            let nameTextFieldVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[nameTextField(30)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameTextField": nameTextField])

            languageView.addConstraints(nameLabelHorizontalConstraints+nameLabelVerticalConstraints)
            languageView.addConstraints(nameTextFieldHorizontalConstraints+nameTextFieldVerticalConstraints)

            sustantiveView.addSubview(languageView)
            
            languageView.translatesAutoresizingMaskIntoConstraints = false

            let horizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[languageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["languageView": languageView])

            sustantiveView.addConstraints(horizontalConstraints)

            if let previewView = previewView {
                let verticalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[previewView]-20-[languageView]",
                    options: NSLayoutConstraint.FormatOptions(),
                    metrics: nil,
                    views: ["previewView": previewView, "languageView": languageView])
                sustantiveView.addConstraints(verticalConstraints)
            } else {
                let verticalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[languageView]",
                    options: NSLayoutConstraint.FormatOptions(),
                    metrics: nil,
                    views: ["languageView": languageView])
                sustantiveView.addConstraints(verticalConstraints)
            }

            previewView = languageView

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
