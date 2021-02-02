//
//  CurrentWordViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 12/01/2021.
//

import UIKit

class CurrentWordViewController: UIViewController {

    private var languages: [String] = []

    private var sustantiveTextfields: [UITextField] = []
    private var verbTextfields: [UITextField] = []
    private var textfields: [[UITextField]] = []

    @IBOutlet weak var mainScrollView: UIScrollView!
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
        prepareVerbView()
        textfields = [sustantiveTextfields, verbTextfields]
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

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

            sustantiveTextfields.append(contentsOf: [nameTextField, genderTextField, pluralTextField])
        }

        for textField in sustantiveTextfields {
            textField.delegate = self
            textField.returnKeyType = .next
        }
        sustantiveTextfields.last?.returnKeyType = .default

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

    private func prepareVerbView() {
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

            let participleLabel = UILabel()
            participleLabel.text = "Participio en \(language)"
            let participleTextField = UITextField()
            participleTextField.borderStyle = .roundedRect
            let participleStack = UIStackView(arrangedSubviews: [participleLabel, participleTextField])
            participleStack.axis = .horizontal
            participleStack.spacing = 20
            participleStack.alignment = .fill
            participleStack.distribution = .fillEqually

            verticalStack.addArrangedSubview(nameStack)
            verticalStack.addArrangedSubview(participleStack)
            verbTextfields.append(contentsOf: [nameTextField, participleTextField])
        }

        for textField in verbTextfields {
            textField.delegate = self
            textField.returnKeyType = .next
        }
        verbTextfields.last?.returnKeyType = .default

        let addButton = UIButton()
        addButton.setTitle("Añadir verbo", for: .normal)
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addVerb), for: .touchUpInside)
        verticalStack.addArrangedSubview(addButton)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verbView.addSubview(verticalStack)

        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[verticalStack]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["verticalStack":verticalStack])
        let stackView_V: [NSLayoutConstraint]
        stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[verticalStack]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: ["verticalStack":verticalStack])

        verbView.addConstraints(stackView_H)
        verbView.addConstraints(stackView_V)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = mainScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        mainScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mainScrollView.contentInset = contentInset
    }

    private func validateSustantiveFields() -> UITextField? {
        for sustantiveTextfield in sustantiveTextfields {
            if sustantiveTextfield.text == "" {
                return sustantiveTextfield
            }
        }
        return nil
    }

    //MARK: - Actions

    @objc
    func addSustantive(sender: UIButton) {
        if let missingTextfield = validateSustantiveFields() {
            missingTextfield.becomeFirstResponder()
            return
        }
        print("Añadiendo sustantivo . . .")
    }

    @objc
    func addVerb(sender: UIButton) {
        print("Añadiendo verbo . . .")
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
        for currentTextfields in textfields {
            if let index = currentTextfields.firstIndex(of: textField) {
                navigateNextTextfield(currentTextfields, index: index)
                break
            }
        }
        return true
    }

    private func navigateNextTextfield(_ textfields: [UITextField], index currentIndex: Int) {
        guard currentIndex < textfields.count - 1 else {
            textfields[currentIndex].resignFirstResponder()
            return
        }
        let nextTextfield = textfields[currentIndex+1]
        nextTextfield.becomeFirstResponder()
    }

}
