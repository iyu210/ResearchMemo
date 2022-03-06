//
//  ReferenceViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/03.
//

import UIKit
import RealmSwift

class ReferenceViewController: UIViewController {
    
    private let realm = try! Realm()
    private var referenceArray = try! Realm().objects(Reference.self)
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ReferenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        referenceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell
        
        let reference = referenceArray[indexPath.row]
        cell.titleLabel.text = "タイトル: " + reference.title
        cell.dcCreatorLabel.text = "著者: " + reference.dcCreator
        cell.dcPublisherLabel.text = "出版者: " + reference.dcPublisher
        cell.prismPublicationNameLabel.text = "収録刊行物: " + reference.prismPublicationName
        cell.dcDateLabel.text = "登録日: " + reference.dcDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedArticleInfoViewController = storyboard?.instantiateViewController(withIdentifier: "SavedArticle") as! SavedArticleInfoViewController
        savedArticleInfoViewController.setupData(reference: referenceArray[indexPath.row])
        self.navigationController?.pushViewController(savedArticleInfoViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
}
