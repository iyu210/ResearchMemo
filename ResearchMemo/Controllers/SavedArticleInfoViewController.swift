//
//  ViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/02/25.
//

import UIKit
import RealmSwift
import PKHUD

class SavedArticleInfoViewController: UIViewController {
    
    private var reference: Reference!
    private let realm = try! Realm()
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorsLabel: UILabel!
    @IBOutlet weak private var publisherLabel: UILabel!
    @IBOutlet weak private var publicationNameLabel: UILabel!
    @IBOutlet weak private var dcDateLabel: UILabel!
    @IBOutlet weak private var descriptionTextView: UITextView!
    @IBOutlet weak var openSafariButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupData(reference: Reference) {
        self.reference = reference
    }
    
    private func setupViews() {
        titleLabel.text = reference.title
        creatorsLabel.text = reference.dcCreator
        publisherLabel.text = reference.dcPublisher
        publicationNameLabel.text = reference.prismPublicationName
        dcDateLabel.text = reference.dcDate
        descriptionTextView.text = reference.descriptionString
        openSafariButton.layer.cornerRadius = 15
        deleteButton.layer.cornerRadius = 15
    }
    
    @IBAction func moveToSafari(_ sender: Any) {
        if reference.link != ""{
            let url = URL(string: reference.link)!
            UIApplication.shared.open(url)
        } else {
            let alertController = UIAlertController(title: "エラー", message: "この文献にはリンクがありません。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteReference(_ sender: Any) {
        
        let alertController = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .default) { _ in
            do {
                try self.realm.write {
                    self.realm.delete(self.reference)
                }
                HUD.flash(.labeledSuccess(title: "削除", subtitle: "完了しました"), delay: 1)
                self.navigationController?.popViewController(animated: true)
            } catch {
                HUD.flash(.labeledError(title: "エラー", subtitle: "削除できませんでした"), delay: 1)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
