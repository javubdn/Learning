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
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 30
        verticalStack.alignment = .fill
        verticalStack.distribution = .fill

        for language in languages {

            let nameLabel = UILabel()
            nameLabel.text = "Palabra en \(language)"
            let nameTextField = UITextField()
            nameTextField.borderStyle = .roundedRect
            let nameStack = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
            nameStack.axis = .horizontal
            nameStack.spacing = 20
            nameStack.alignment = .fill
            nameStack.distribution = .fillEqually

            let genderLabel = UILabel()
            genderLabel.text = "Género en \(language)"
            let genderTextField = UITextField()
            genderTextField.borderStyle = .roundedRect
            let genderStack = UIStackView(arrangedSubviews: [genderLabel, genderTextField])
            genderStack.axis = .horizontal
            genderStack.spacing = 20
            genderStack.alignment = .fill
            genderStack.distribution = .fillEqually

            let pluralLabel = UILabel()
            pluralLabel.text = "Plural en \(language)"
            let pluralTextField = UITextField()
            pluralTextField.borderStyle = .roundedRect
            let pluralStack = UIStackView(arrangedSubviews: [pluralLabel, pluralTextField])
            pluralStack.axis = .horizontal
            pluralStack.spacing = 20
            pluralStack.alignment = .fill
            pluralStack.distribution = .fillEqually

            verticalStack.addArrangedSubview(nameStack)
            verticalStack.addArrangedSubview(genderStack)
            verticalStack.addArrangedSubview(pluralStack)
        }

        let addButton = UIButton()
        addButton.setTitle("Añadir sustantivo", for: .normal)
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addSustantive), for: .touchUpInside)
        verticalStack.addArrangedSubview(addButton)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        sustantiveView.addSubview(verticalStack)

        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[verticalStack]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["verticalStack":verticalStack])
        let stackView_V: [NSLayoutConstraint]
        stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[verticalStack]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: ["verticalStack":verticalStack])

        sustantiveView.addConstraints(stackView_H)
        sustantiveView.addConstraints(stackView_V)
    }

    @objc
    func addSustantive(sender: UIButton) {
        print("Añadiendo sustantivo . . .")
    }

}

extension CurrentWordViewController: ItemSelectorDelegate {

    func valueChanged(_ selector: ItemSelector) {
        switch selector.itemId {
        case .initial:
            if selector.currentIndex == 0 {
                sustantiveView.isHidden = false
                verbView.isHidden = true
                self.view.bringSubviewToFront(sustantiveView)
            } else if selector.currentIndex == 1 {
                sustantiveView.isHidden = true
                verbView.isHidden = false
                self.view.bringSubviewToFront(verbView)
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
