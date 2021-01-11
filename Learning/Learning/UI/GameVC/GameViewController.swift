//
//  GameViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import UIKit

class GameViewController: UIViewController {

    var initLanguage = 0
    var endLanguage = 1
    var maximumScore = 5
    private var words: [Word]?
    private var currentScore: Score?
    var indexWordSelected = 0

    @IBOutlet weak var solutionTextField: UITextField!
    @IBOutlet weak var progressView: ProgressGame!
    @IBOutlet weak var textToTranslateLabel: UILabel!
    @IBOutlet weak var solutionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var solutionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        title = "Juego"
        tabBarItem.title = "Juego"
        progressView.maximumValue = maximumScore
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let wordsAPI = WordsAPI()
        words = wordsAPI.getListWords(initLanguage: initLanguage, endLanguage: endLanguage)
        solutionTextField.delegate = self
        currentScore = Score()
        prepareScreen()
    }

    private func prepareScreen() {
        guard let words = words else {
            return
        }
        let numberWords = words.count
        if numberWords > 0 {
            indexWordSelected = Int(arc4random() % UInt32(numberWords))
            let currentWord = words[indexWordSelected]
            textToTranslateLabel.text = currentWord.initialWord
        }
        correctButton.isEnabled = false
        nextButton.isHidden = true
        solutionButton.isEnabled = true
        solutionTextField.text = ""
        solutionLabel.text = ""
    }

    //MARK: - Actions

    @IBAction func correctButtonPressed(_ sender: UIButton) {
        guard let words = words else {
            return
        }
        let currentWord = words[indexWordSelected]
        let solution = currentWord.endWord
        let userWord = solutionTextField.text?.uppercased().trimmingCharacters(in: .whitespaces)
        let correctWord = solution.uppercased().trimmingCharacters(in: .whitespaces)
        if userWord == correctWord {
            solutionLabel.text = "CORRECTO"
            solutionLabel.textColor = .green
            nextButton.isHidden = false
            solutionButton.isEnabled = false
            currentScore?.numSuccess += 1
            progressView.addSuccess()
        } else {
            solutionLabel.text = "INCORRECTO"
            solutionLabel.textColor = .red
        }
    }

    @IBAction func solutionButtonPressed(_ sender: UIButton) {
        guard let words = words else {
            return
        }
        let currentWord = words[indexWordSelected]
        let solution = currentWord.endWord
        solutionLabel.text = solution
        solutionLabel.textColor = .black
        solutionLabel.alpha = 0
        UIView.animate(withDuration: 1) {
            self.solutionLabel.alpha = 1
        }
        nextButton.isHidden = false
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        prepareScreen()
    }

    @IBAction func solutionTextFieldChanged(_ sender: Any) {
        correctButton.isEnabled = solutionTextField.text != ""
    }

}

extension GameViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
