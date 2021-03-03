//
//  WordsViewController.swift
//  Learning
//
//  Created by Javi Castillo Risco on 11/01/2021.
//

import UIKit

class WordsViewController: UIViewController {

    @IBOutlet weak var wordsTableView: UITableView!
    var wordsList: [Word] = []
    private let cellIdentifier = "WordTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let wordsAPI = WordsAPI()
        if let wordsList = wordsAPI.getListWords(initLanguage: 0, endLanguage: 1) {
            self.wordsList = wordsList
        }
        wordsTableView.reloadData()
    }

    private func prepareView() {
        title = "Palabras"
        tabBarItem.title = "Palabras"
        wordsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    //MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let currentWordViewController = CurrentWordViewController()
        navigationController?.pushViewController(currentWordViewController, animated: true)
    }

}

extension WordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let currentWordViewController = CurrentWordViewController()
        currentWordViewController.setMode(.info)
        currentWordViewController.setWord(wordsList[indexPath.row])
        navigationController?.pushViewController(currentWordViewController, animated: true)
    }
}

extension WordsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }
        let word = wordsList[indexPath.row]
        cell.initLabel.text = word.initialWord
        cell.endLabel.text = word.endWord
        return cell
    }

}
