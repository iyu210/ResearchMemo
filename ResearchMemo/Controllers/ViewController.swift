//
//  ViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/02/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var resultArray = [Article]()
    private var arrayCount = 0
    private var activityIndicatorView = UIActivityIndicatorView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        view.addSubview(activityIndicatorView)
        tableView.delegate = self
        tableView.dataSource = self
        searchTextFiled.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func searchButton(_ sender: Any) {
        seachArticles()
    }
   
    private func seachArticles() {
        guard let searchText = searchTextFiled.text, !searchTextFiled.text!.isEmpty else {
            alert()
            searchTextFiled.text = ""
            return
        }
        activityIndicatorView.startAnimating()
        searchTextFiled.resignFirstResponder()
        let ciniiSearch = CiniiSearch(searchText: searchText)
        ciniiSearch.searchDataSource = self
        ciniiSearch.setupData()
    }
    
    private func alert() {
        let alertController = UIAlertController(title: "検索できません。", message: "キーワードを正しく入力してください。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SearchDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = resultArray[indexPath.row].title
        let creatorsString = resultArray[indexPath.row].dcCreator?.reduce("", {$0 + $1 + "  "})
        cell.dcCreatorLabel.text = creatorsString
        cell.prismPublicationNameLabel.text = resultArray[indexPath.row].prismPublicationName
        cell.dcPublisherLabel.text = resultArray[indexPath.row].dcPublisher
        cell.dcDateLabel.text = resultArray[indexPath.row].dcDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        seachArticles()
        return textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let articleInfoViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleInfo") as! ArticleInfoViewController
        articleInfoViewController.setupData(article: resultArray[indexPath.row])
        navigationController?.pushViewController(articleInfoViewController, animated: true)
    }
    
    func searchResults(articleArray: [Article], count: Int) {
        resultArray = articleArray
        arrayCount = count
        tableView.reloadData()
        activityIndicatorView.stopAnimating()
    }
}
