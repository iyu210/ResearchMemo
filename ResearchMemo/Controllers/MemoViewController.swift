//
//  MemoViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/05.
//

import UIKit
import RealmSwift
import PKHUD

class MemoViewController: UIViewController {
    
    private let realm = try! Realm()
    private var memo: Memo!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var datePicker: UIDatePicker!
    @IBOutlet weak private var memoTextView: UITextView!
    @IBOutlet weak private var saveButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        titleTextField.text = memo.title
        datePicker.date = memo.date
        memoTextView.text = memo.memo
        saveButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupDate(selectedMemo: Memo) {
        memo = selectedMemo
    }
  
    @IBAction private func saveButton(_ sender: Any) {
        do {
            try realm.write {
                memo.title = titleTextField.text ?? ""
                memo.date = datePicker.date
                memo.memo = memoTextView.text
                HUD.flash(.labeledSuccess(title: nil, subtitle: "保存しました"), delay: 1)
                realm.add(memo, update: .modified)
            }
        } catch {
            HUD.flash(.labeledError(title: "エラー", subtitle: "保存できませんでした。"), delay: 1)
        }
    }
    
    @IBAction private func deleteButton(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .default) { _ in
            do {
                try self.realm.write {
                    self.realm.delete(self.memo)
                }
                HUD.flash(.labeledSuccess(title: nil, subtitle: "削除しました"), delay: 1)
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
