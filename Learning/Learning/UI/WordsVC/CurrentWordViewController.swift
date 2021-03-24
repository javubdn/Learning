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
    private let TAG_ADJ_WORD = 7
    private let TAG_ADV_WORD = 8
    private let TAG_EDIT_BUTTON = 9
    private let TAG_ACCEPT_BUTTON = 10
    private let TAG_CANCEL_BUTTON = 11

    private var languages: [String] = []

    private var sustantiveTextfields: [UITextField] = []
    private var verbTextfields: [UITextField] = []
    private var adjectiveTextfields: [UITextField] = []
    private var adverbTextfields: [UITextField] = []
    private var textfields: [[UITextField]] = []

    private var mode: Mode = .new
    private var currentWord: Word?

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeWordStackView: UIStackView!
    @IBOutlet weak var typeItemSelector: ItemSelector!
    @IBOutlet weak var sustantiveView: UIView!
    @IBOutlet weak var verbView: UIView!
    @IBOutlet weak var adjectiveView: UIView!
    @IBOutlet weak var adverbView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScreen()
    }

    private func prepareScreen() {
        typeItemSelector.listItems = ["Sustantivo", "Verbo", "Adjetivo", "Adverbio"]
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
        prepareView(sustantiveView, with: FieldsView(nameFields: ["Palabra en", "Género en", "Plural en"], tagFields: [TAG_SUST_WORD, TAG_SUST_GENDER, TAG_SUST_PLURAL], name: "Sustantivo", nameTextFields: 0))
        prepareView(verbView, with: FieldsView(nameFields: ["Palabra en", "Participio en"], tagFields: [TAG_VERB_WORD, TAG_VERB_PART], name: "Verbo", nameTextFields: 1))
        prepareView(adjectiveView, with: FieldsView(nameFields: ["Palabra en"], tagFields: [TAG_ADJ_WORD], name: "Adjetivo", nameTextFields: 2))
        prepareView(adverbView, with: FieldsView(nameFields: ["Palabra en"], tagFields: [TAG_ADV_WORD], name: "Adverbio", nameTextFields: 3))
        textfields = [sustantiveTextfields, verbTextfields, adjectiveTextfields, adverbTextfields]
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
        adjectiveView.isHidden = true
        adverbView.isHidden = true
        if mode != .new {
            if let sustantive = currentWord as? Sustantive {
                sustantiveView.isHidden = false
                updateSustantiveView(sustantive)
            } else if let verb = currentWord as? Verb {
                verbView.isHidden = false
                updateVerbView(verb)
            } else if let adjective = currentWord as? Adjective {
                adjectiveView.isHidden = false
                updateAdjectiveView(adjective)
            } else if let adverb = currentWord as? Adverb {
                adverbView.isHidden = false
                updateAdverbView(adverb)
            }
        } else {
            if typeItemSelector.currentIndex == 0 {
                sustantiveView.isHidden = false
                verbView.isHidden = true
                adjectiveView.isHidden = true
                adverbView.isHidden = true
                updateSustantiveView(nil)
            } else if typeItemSelector.currentIndex == 1 {
                sustantiveView.isHidden = true
                verbView.isHidden = false
                adjectiveView.isHidden = true
                adverbView.isHidden = true
                updateVerbView(nil)
            } else if typeItemSelector.currentIndex == 2 {
                sustantiveView.isHidden = true
                verbView.isHidden = true
                adjectiveView.isHidden = false
                adverbView.isHidden = true
                updateAdjectiveView(nil)
            } else if typeItemSelector.currentIndex == 3 {
                sustantiveView.isHidden = true
                verbView.isHidden = true
                adjectiveView.isHidden = true
                adverbView.isHidden = false
                updateAdverbView(nil)
            }
        }
    }

    private func updateSustantiveView(_ sustantive: Sustantive?) {
        for textField in sustantiveTextfields {
            textField.isEnabled = mode != .info
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
            textField.isEnabled = mode != .info
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

    private func updateAdjectiveView(_ adjective: Adjective?) {
        for textField in adjectiveTextfields {
            textField.isEnabled = mode != .info
        }
        if let addButton = adjectiveView.viewWithTag(TAG_ADD_BUTTON) as? UIButton {
            addButton.isHidden = mode != .new
        }
        if let editButton = adjectiveView.viewWithTag(TAG_EDIT_BUTTON) as? UIButton {
            editButton.isHidden = mode != .info
        }
        if let acceptButton = adjectiveView.viewWithTag(TAG_ACCEPT_BUTTON) as? UIButton {
            acceptButton.isHidden = mode != .edit
        }
        if let cancelButton = adjectiveView.viewWithTag(TAG_CANCEL_BUTTON) as? UIButton {
            cancelButton.isHidden = mode != .edit
        }
        if let adjInit = adjectiveView.viewWithTag(TAG_ADJ_WORD * 100 + 0) as? UITextField {
            adjInit.text = adjective?.initialWord
        }
        if let adjEnd = adjectiveView.viewWithTag(TAG_ADJ_WORD * 100 + 1) as? UITextField {
            adjEnd.text = adjective?.endWord
        }
    }

    private func updateAdverbView(_ adverb: Adverb?) {
        for textField in adverbTextfields {
            textField.isEnabled = mode != .info
        }
        if let addButton = adverbView.viewWithTag(TAG_ADD_BUTTON) as? UIButton {
            addButton.isHidden = mode != .new
        }
        if let editButton = adverbView.viewWithTag(TAG_EDIT_BUTTON) as? UIButton {
            editButton.isHidden = mode != .info
        }
        if let acceptButton = adverbView.viewWithTag(TAG_ACCEPT_BUTTON) as? UIButton {
            acceptButton.isHidden = mode != .edit
        }
        if let cancelButton = adverbView.viewWithTag(TAG_CANCEL_BUTTON) as? UIButton {
            cancelButton.isHidden = mode != .edit
        }
        if let advInit = adverbView.viewWithTag(TAG_ADV_WORD * 100 + 0) as? UITextField {
            advInit.text = adverb?.initialWord
        }
        if let advEnd = adverbView.viewWithTag(TAG_ADV_WORD * 100 + 1) as? UITextField {
            advEnd.text = adverb?.endWord
        }
    }

    struct FieldsView {
        let nameFields: [String]
        let tagFields: [Int]
        let name: String
        let nameTextFields: Int
    }

    private func prepareView(_ currentView: UIView, with fields: FieldsView) {
        guard fields.nameFields.count == fields.tagFields.count else {
            return
        }
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 30
        verticalStack.alignment = .fill
        verticalStack.distribution = .fill
        var currentTextfields: [UITextField]
        if fields.nameTextFields == 0 {
            currentTextfields = sustantiveTextfields
        } else if fields.nameTextFields == 1 {
            currentTextfields = verbTextfields
        } else if fields.nameTextFields == 2 {
            currentTextfields = adjectiveTextfields
        } else {
            currentTextfields = adverbTextfields
        }
        for language in languages {
            for index in 0..<fields.nameFields.count {
                let valueLabel = UILabel()
                valueLabel.text = "\(fields.nameFields[index]) \(language)"
                let valueTextField = UITextField()
                valueTextField.tag = fields.tagFields[index] * 100 + languages.firstIndex(of: language)!
                valueTextField.borderStyle = .roundedRect
                let valueStack = UIStackView(arrangedSubviews: [valueLabel, valueTextField])
                valueStack.axis = .horizontal
                valueStack.spacing = 20
                valueStack.alignment = .fill
                valueStack.distribution = .fillEqually
                verticalStack.addArrangedSubview(valueStack)
                currentTextfields.append(contentsOf: [valueTextField])
            }
        }

        for textField in currentTextfields {
            textField.delegate = self
            textField.returnKeyType = .next
        }
        currentTextfields.last?.returnKeyType = .default

        if fields.nameTextFields == 0 {
            sustantiveTextfields = currentTextfields
        } else if fields.nameTextFields == 1 {
            verbTextfields = currentTextfields
        } else if fields.nameTextFields == 2 {
            adjectiveTextfields = currentTextfields
        } else {
            adverbTextfields = currentTextfields
        }

        let addButton = UIButton()
        addButton.setTitle("Añadir \(fields.name)", for: .normal)
        addButton.tag = TAG_ADD_BUTTON
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(addWord), for: .touchUpInside)
        verticalStack.addArrangedSubview(addButton)
        
        let editButton = UIButton()
        editButton.setTitle("Editar \(fields.name)", for: .normal)
        editButton.tag = TAG_EDIT_BUTTON
        editButton.backgroundColor = .blue
        editButton.addTarget(self, action: #selector(editWord), for: .touchUpInside)
        verticalStack.addArrangedSubview(editButton)

        let acceptButton = UIButton()
        acceptButton.setTitle("Aceptar", for: .normal)
        acceptButton.tag = TAG_ACCEPT_BUTTON
        acceptButton.backgroundColor = .blue
        acceptButton.addTarget(self, action: #selector(acceptChangeWord), for: .touchUpInside)
        verticalStack.addArrangedSubview(acceptButton)

        let cancelButton = UIButton()
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.tag = TAG_CANCEL_BUTTON
        cancelButton.backgroundColor = .blue
        cancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
        verticalStack.addArrangedSubview(cancelButton)

        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        currentView.addSubview(verticalStack)

        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[verticalStack]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["verticalStack": verticalStack])
        let stackView_V: [NSLayoutConstraint]
        stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[verticalStack]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: ["verticalStack": verticalStack])

        currentView.addConstraints(stackView_H)
        currentView.addConstraints(stackView_V)

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

    private func validateTextfields(_ textfields: [UITextField]) -> UITextField? {
        for textfield in textfields {
            if textfield.text == "" {
                return textfield
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

    //MARK: - Helpers

    private func clearFields() {
        for textfieldList in textfields {
            for textfield in textfieldList {
                textfield.text = ""
            }
        }
    }

    private func backToInfoMode() {
        mode = .info
        updateScreen()
    }

    //MARK: - Actions

    @objc
    func addWord(sender: UIButton) {
        let currentTextfields: [UITextField]
        let word: Word
        if typeItemSelector.currentIndex == 0 {
            currentTextfields = sustantiveTextfields
            word = Sustantive(id: "",
                              initialWord: sustantiveTextfields[0].text!,
                              endWord: sustantiveTextfields[3].text!,
                              initialGenre: sustantiveTextfields[1].text!,
                              endGenre: sustantiveTextfields[4].text!,
                              initialPlural: sustantiveTextfields[2].text!,
                              endPlural: sustantiveTextfields[5].text!)
        } else if typeItemSelector.currentIndex == 1 {
            currentTextfields = verbTextfields
            word = Verb(id: "",
                        initialWord: verbTextfields[0].text!,
                        endWord: verbTextfields[2].text!,
                        initialPart: verbTextfields[1].text!,
                        endPart: verbTextfields[3].text!)
        } else if typeItemSelector.currentIndex == 2 {
            currentTextfields = adjectiveTextfields
            word = Adjective(id: "", initialWord: adjectiveTextfields[0].text!, endWord: adjectiveTextfields[1].text!)
        } else if typeItemSelector.currentIndex == 3 {
            currentTextfields = adverbTextfields
            word = Adverb(id: "", initialWord: adverbTextfields[0].text!, endWord: adverbTextfields[1].text!)
        } else {
            return
        }
        if let missingTextfield = validateTextfields(currentTextfields) {
            missingTextfield.becomeFirstResponder()
            return
        }
        let wordsAPI = WordsAPI()
        wordsAPI.addWord(word)
        clearFields()
    }

    @objc
    func editWord(sender: UIButton) {
        mode = .edit
        updateScreen()
    }

    @objc
    func acceptChangeWord(sender: UIButton) {
        guard let currentWord = currentWord else {
            return
        }
        let currentTextfields: [UITextField]
        let word: Word
        if currentWord is Sustantive {
            currentTextfields = sustantiveTextfields
            word = Sustantive(id: currentWord.id,
                              initialWord: sustantiveTextfields[0].text!,
                              endWord: sustantiveTextfields[3].text!,
                              initialGenre: sustantiveTextfields[1].text!,
                              endGenre: sustantiveTextfields[4].text!,
                              initialPlural: sustantiveTextfields[2].text!,
                              endPlural: sustantiveTextfields[5].text!)
        } else if currentWord is Verb {
            currentTextfields = verbTextfields
            word = Verb(id: currentWord.id,
                        initialWord: verbTextfields[0].text!,
                        endWord: verbTextfields[2].text!,
                        initialPart: verbTextfields[1].text!,
                        endPart: verbTextfields[3].text!)
        } else if currentWord is Adjective {
            currentTextfields = adjectiveTextfields
            word = Adjective(id: currentWord.id, initialWord: adjectiveTextfields[0].text!, endWord: adjectiveTextfields[1].text!)
        } else if currentWord is Adverb {
            currentTextfields = adverbTextfields
            word = Adverb(id: currentWord.id, initialWord: adverbTextfields[0].text!, endWord: adverbTextfields[1].text!)
        } else {
            return
        }
        if let missingTextfield = validateTextfields(currentTextfields) {
            missingTextfield.becomeFirstResponder()
            return
        }
        let wordsAPI = WordsAPI()
        self.currentWord = word
        wordsAPI.updateWord(word)
        backToInfoMode()
    }

    @objc
    func cancelEdit(sender: UIButton) {
        backToInfoMode()
    }

}

extension CurrentWordViewController: ItemSelectorDelegate {

    func valueChanged(_ selector: ItemSelector) {
        switch selector.itemId {
        case .initial:
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
