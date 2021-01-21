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
                withVisualFormat: "V:|-0-[nameLabel(30)]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel])

            let nameTextField = UITextField()
            nameTextField.borderStyle = .roundedRect
            nameTextField.delegate = self
            nameTextField.isUserInteractionEnabled = true
            nameTextField.isEnabled = true
            languageView.addSubview(nameTextField)
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            let nameTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[nameLabel]-20-[nameTextField(100)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel, "nameTextField": nameTextField])
            let nameTextFieldVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[nameTextField(30)]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameTextField": nameTextField])

            let genderLabel = UILabel()
            genderLabel.text = "Género en \(language)"
            languageView.addSubview(genderLabel)
            genderLabel.translatesAutoresizingMaskIntoConstraints = false
            let genderLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[genderLabel]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["genderLabel": genderLabel])
            let genderLabelVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[nameLabel]-20-[genderLabel(30)]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameLabel": nameLabel, "genderLabel": genderLabel])

            let genderTextField = UITextField()
            genderTextField.borderStyle = .roundedRect
            languageView.addSubview(genderTextField)
            genderTextField.translatesAutoresizingMaskIntoConstraints = false
            let genderTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[genderLabel]-20-[genderTextField(100)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["genderLabel": genderLabel, "genderTextField": genderTextField])
            let genderTextFieldVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[nameTextField]-20-[genderTextField(30)]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["nameTextField": nameTextField, "genderTextField": genderTextField])

            let pluralLabel = UILabel()
            pluralLabel.text = "Plural en \(language)"
            languageView.addSubview(pluralLabel)
            pluralLabel.translatesAutoresizingMaskIntoConstraints = false
            let pluralLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[pluralLabel]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["pluralLabel": pluralLabel])
            let pluralLabelVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[genderLabel]-20-[pluralLabel(30)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["genderLabel": genderLabel, "pluralLabel": pluralLabel])

            let pluralTextField = UITextField()
            pluralTextField.borderStyle = .roundedRect
            languageView.addSubview(pluralTextField)
            pluralTextField.translatesAutoresizingMaskIntoConstraints = false
            let pluralTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[pluralLabel]-20-[pluralTextField(100)]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["pluralLabel": pluralLabel, "pluralTextField": pluralTextField])
            let pluralTextFieldVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[genderTextField]-20-[pluralTextField(30)]",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views: ["genderTextField": genderTextField, "pluralTextField": pluralTextField])

            languageView.addConstraints(nameLabelHorizontalConstraints+nameLabelVerticalConstraints)
            languageView.addConstraints(nameTextFieldHorizontalConstraints+nameTextFieldVerticalConstraints)
            languageView.addConstraints(genderLabelHorizontalConstraints+genderLabelVerticalConstraints)
            languageView.addConstraints(genderTextFieldHorizontalConstraints+genderTextFieldVerticalConstraints)
            languageView.addConstraints(pluralLabelHorizontalConstraints+pluralLabelVerticalConstraints)
            languageView.addConstraints(pluralTextFieldHorizontalConstraints+pluralTextFieldVerticalConstraints)

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

extension CurrentWordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
