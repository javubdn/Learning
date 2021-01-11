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

    private func prepareView() {
        title = "Palabras"
        tabBarItem.title = "Palabras"
        wordsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        let wordsAPI = WordsAPI()
        if let wordsList = wordsAPI.getListWords(initLanguage: 0, endLanguage: 1) {
            self.wordsList = wordsList
        }
        wordsTableView.reloadData()
    }
    
}

extension WordsViewController: UITableViewDelegate {

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
