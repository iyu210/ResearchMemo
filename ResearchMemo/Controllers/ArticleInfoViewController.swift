//
//  ArticleInfoViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/02.
//

import UIKit
import RealmSwift
import PKHUD

class ArticleInfoViewController: UIViewController {
    
    private var article: Article!
    private var realm = try! Realm()
    private let reference = Reference()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var creatorsLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var publicationNameLabel: UILabel!
    @IBOutlet private weak var dcDateLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var moveToSafariButton: UIButton!
    @IBOutlet private weak var writeArticleRealmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupData(article: Article) {
        self.article = article
    }
    
    private func setupViews() {
        titleLabel.text = article.title
        creatorsLabel.text = article.dcCreator?.reduce("", {$0 + $1 + "  "})
        publisherLabel.text = article.dcPublisher
        publicationNameLabel.text = article.prismPublicationName
        dcDateLabel.text = article.dcDate
        descriptionTextView.text = article.description
        moveToSafariButton.layer.cornerRadius = 15
        writeArticleRealmButton.layer.cornerRadius = 15
    }
    
    @IBAction private func moveToSafari(_ sender: Any) {
        if let urlString = article.link {
            let url = URL(string: urlString)!
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction private func writeArticleRealm(_ sender: Any) {
        do {
            let empty = " "
            try realm.write {
                reference.title = article.title ?? empty
                reference.link = article.link ?? empty
                reference.dcCreator = (article.dcCreator?.reduce("", {$0 + $1 + "  "}))!
                reference.dcPublisher = article.dcPublisher ?? empty
                reference.prismPublicationName = article.prismPublicationName ?? empty
                reference.descriptionString = article.description ?? empty
                realm.add(reference, update: .modified)
                HUD.flash(.labeledSuccess(title: "追加完了", subtitle: nil), delay: 1)
            }
        } catch {
            HUD.flash(.labeledError(title: "エラー", subtitle: "保存できませんでした"), delay: 1)
        }
    }
}
