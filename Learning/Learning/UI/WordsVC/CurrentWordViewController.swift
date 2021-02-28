//
//  CurrentWordViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 12/01/2021.
//

import UIKit

enum Mode {
    case new
    case info
    case edit
}

class CurrentWordViewController: UIViewController {

    private let TAG_ADD_BUTTON = 1
    private let TAG_SUST_WORD = 2
    private let TAG_SUST_GENDER = 3
    private let TAG_SUST_PLURAL = 4
    private let TAG_VERB_WORD = 5
    private let TAG_VERB_PART = 6
    private let TAG_EDIT_BUTTON = 7
    private let TAG_ACCEPT_BUTTON = 8
    private let TAG_CANCEL_BUTTON = 9

    private var languages: [String] = []

    private var sustantiveTextfields: [UITextField] = []
    private var verbTextfields: [UITextField] = []
    private var textfields: [[UITextField]] = []

    private var mode: Mode = .new
    private var currentWord: Word?

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeWordStackView: UIStackView!
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

        updateScreen()
    }

    private func updateScreen() {
        titleLabel.isHidden = self.mode != .new
        typeWordStackView.isHidden = self.mode != .new
        sustantiveView.isHidden = true
        verbView.isHidden = true
        if mode != .new {
            if let sustantive = currentWord as? Sustantive {
                sustantiveView.isHidden = false
                updateSustantiveView(sustantive)
            } else if let verb = currentWord as? Verb {
                verbView.isHidden = false
                updateVerbView(verb)
            }
        } else {
            if typeItemSelector.currentIndex == 0 {
                sustantiveView.isHidden = false
                verbView.isHidden = true
                updateSustantiveView(nil)
            } else if typeItemSelector.currentIndex == 1 {
                sustantiveView.isHidden = true
                verbView.isHidden = false
                updateVerbView(nil)
            }
        }
    }

    private func updateSustantiveView(_ sustantive: Sustantive?) {
        for textField in sustantiveTextfields {
            textField.isEnabled = mode == .new
        }
        if let addButton = sustantiveView.viewWithTag(TAG_ADD_BUTTON) as? UIButton {
            addButton.isHidden = mode != .new
        }
        if let editButton = sustantiveView.viewWithTag(TAG_EDIT_BUTTON) as? UIButton {
            editButton.isHidden = mode != .info
        }
        if let acceptButton = sustantiveView.viewWithTag(TAG_ACCEPT_BUTTON) as? UIButton {
            acceptButton.isHidden = mode != .edit
        }
        if let cancelButton = sustantiveView.viewWithTag(TAG_CANCEL_BUTTON) as? UIButton {
            cancelButton.isHidden = mode != .edit
        }
        if let sustantiveInit = sustantiveView.viewWithTag(TAG_SUST_WORD * 100 + 0) as? UITextField {
            sustantiveInit.text = sustantive?.initialWord
        }
        if let sustantiveEnd = sustantiveView.viewWithTag(TAG_SUST_WORD * 100 + 1) as? UITextField {
            sustantiveEnd.text = sustantive?.endWord
        }
        if let genderInit = sustantiveView.viewWithTag(TAG_SUST_GENDER * 100 + 0) as? UITextField {
            genderInit.text = sustantive?.initialGenre
        }
        if let genderEnd = sustantiveView.viewWithTag(TAG_SUST_GENDER * 100 + 1) as? UITextField {
            genderEnd.text = sustantive?.endGenre
        }
        if let pluralInit = sustantiveView.viewWithTag(TAG_SUST_PLURAL * 100 + 0) as? UITextField {
            pluralInit.text = sustantive?.initialPlural
        }
        if let pluralEnd = sustantiveView.viewWithTag(TAG_SUST_PLURAL * 100 + 1) as? UITextField {
            pluralEnd.text = sustantive?.endPlural
        }

    }

    private func updateVerbView(_ verb: Verb?) {
        for textField in verbTextfields {
            textField.isEnabled = mode == .new
        }
        if let addButton = verbView.viewWithTag(TAG_ADD_BUTTON) as? UIButton {
            addButton.isHidden = mode != .new
        }
        if let editButton = verbView.viewWithTag(TAG_EDIT_BUTTON) as? UIButton {
            editButton.isHidden = mode != .info
        }
        if let acceptButton = verbView.viewWithTag(TAG_ACCEPT_BUTTON) as? UIButton {
            acceptButton.isHidden = mode != .edit
        }
        if let cancelButton = verbView.viewWithTag(TAG_CANCEL_BUTTON) as? UIButton {
            cancelButton.isHidden = mode != .edit
        }
        if let verbInit = verbView.viewWithTag(TAG_VERB_WORD * 100 + 0) as? UITextField {
            verbInit.text = verb?.initialWord
        }
        if let verbEnd = verbView.viewWithTag(TAG_VERB_WORD * 100 + 1) as? UITextField {
            verbEnd.text = verb?.endWord
        }
        if let partInit = verbView.viewWithTag(TAG_VERB_PART * 100 + 0) as? UITextField {
            partInit.text = verb?.initialPart
        }
        if let partEnd = verbView.viewWithTag(TAG_VERB_PART * 100 + 1) as? UITextField {
            partEnd.text = verb?.endPart
        }

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
            nameTextField.tag = TAG_SUST_WORD * 100 + languages.firstIndex(of: language)!
            nameTextField.borderStyle = .roundedRect
            let nameStack = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
            nameStack.axis = .horizontal
            nameStack.spacing = 20
            nameStack.alignment = .fill
            nameStack.distribution = .fillEqually

            let genderLabel = UILabel()
            genderLabel.text = "Género en \(language)"
            let genderTextField = UITextField()
            genderTextField.tag = TAG_SUST_GENDER * 100 + languages.firstIndex(of: language)!
            genderTextField.borderStyle = .roundedRect
            let genderStack = UIStackView(arrangedSubviews: [genderLabel, genderTextField])
            genderStack.axis = .horizontal
            genderStack.spacing = 20
            genderStack.alignment = .fill
            genderStack.distribution = .fillEqually

            let pluralLabel = UILabel()
            pluralLabel.text = "Plural en \(language)"
            let pluralTextField = UITextField()
            pluralTextField.tag = TAG_SUST_PLURAL * 100 + languages.firstIndex(of: language)!
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
        addButton.tag = TAG_ADD_BUTTON
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addSustantive), for: .touchUpInside)
        verticalStack.addArrangedSubview(addButton)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        sustantiveView.addSubview(verticalStack)

        let editButton = UIButton()
        editButton.setTitle("Editar sustantivo", for: .normal)
        editButton.tag = TAG_EDIT_BUTTON
        editButton.backgroundColor = .blue
        editButton.addTarget(self, action: #selector(editSustantive), for: .touchUpInside)
        verticalStack.addArrangedSubview(editButton)

        let acceptButton = UIButton()
        acceptButton.setTitle("Aceptar", for: .normal)
        acceptButton.tag = TAG_ACCEPT_BUTTON
        acceptButton.backgroundColor = .blue
        acceptButton.addTarget(self, action: #selector(acceptSustantive), for: .touchUpInside)
        verticalStack.addArrangedSubview(acceptButton)

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.tag = TAG_CANCEL_BUTTON
        cancelButton.backgroundColor = .blue
        cancelButton.addTarget(self, action: #selector(cancelSustantive), for: .touchUpInside)
        verticalStack.addArrangedSubview(cancelButton)

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
            nameTextField.tag = TAG_VERB_WORD * 100 + languages.firstIndex(of: language)!
            nameTextField.borderStyle = .roundedRect
            let nameStack = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
            nameStack.axis = .horizontal
            nameStack.spacing = 20
            nameStack.alignment = .fill
            nameStack.distribution = .fillEqually

            let participleLabel = UILabel()
            participleLabel.text = "Participio en \(language)"
            let participleTextField = UITextField()
            participleTextField.tag = TAG_VERB_PART * 100 + languages.firstIndex(of: language)!
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
        addButton.tag = TAG_ADD_BUTTON
        addButton.setTitle("Añadir verbo", for: .normal)
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addVerb), for: .touchUpInside)
        verticalStack.addArrangedSubview(addButton)

        let editButton = UIButton()
        editButton.setTitle("Editar verbo", for: .normal)
        editButton.tag = TAG_EDIT_BUTTON
        editButton.backgroundColor = .blue
        editButton.addTarget(self, action: #selector(editVerb), for: .touchUpInside)
        verticalStack.addArrangedSubview(editButton)

        let acceptButton = UIButton()
        acceptButton.setTitle("Aceptar", for: .normal)
        acceptButton.tag = TAG_ACCEPT_BUTTON
        acceptButton.backgroundColor = .blue
        acceptButton.addTarget(self, action: #selector(acceptVerb), for: .touchUpInside)
        verticalStack.addArrangedSubview(acceptButton)

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.tag = TAG_CANCEL_BUTTON
        cancelButton.backgroundColor = .blue
        cancelButton.addTarget(self, action: #selector(cancelVerb), for: .touchUpInside)
        verticalStack.addArrangedSubview(cancelButton)

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

    private func validateVerbFields() -> UITextField? {
        for verbTextfield in verbTextfields {
            if verbTextfield.text == "" {
                return verbTextfield
            }
        }
        return nil
    }

    func setMode(_ mode: Mode) {
        self.mode = mode
    }

    func setWord(_ word: Word) {
        currentWord = word
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
    func editSustantive(sender: UIButton) {
        mode = .edit
        updateScreen()
    }

    @objc
    func acceptSustantive(sender: UIButton) {
        mode = .info
        updateScreen()
    }

    @objc
    func cancelSustantive(sender: UIButton) {
        mode = .info
        updateScreen()
    }

    @objc
    func addVerb(sender: UIButton) {
        if let missingTextfield = validateVerbFields() {
            missingTextfield.becomeFirstResponder()
            return
        }
        print("Añadiendo verbo . . .")
    }

    @objc
    func editVerb(sender: UIButton) {
        mode = .edit
        updateScreen()
    }

    @objc
    func acceptVerb(sender: UIButton) {
        mode = .info
        updateScreen()
    }

    @objc
    func cancelVerb(sender: UIButton) {
        mode = .info
        updateScreen()
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
            updateScreen()
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
