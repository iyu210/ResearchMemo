//
//  ResearchMemoListViewController.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/05.
//

import UIKit
import RealmSwift
import SwiftUI

class MemoListViewController: UIViewController {
    
    private let realm = try! Realm()
    private var memoArray = try! Realm().objects(Memo.self).sorted(byKeyPath: "date", ascending: true)
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
    
    @IBAction func createNewMemoButton(_ sender: Any) {
        let memoViewController = storyboard?.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        let memo = Memo()
        let memos =  realm.objects(Memo.self)
        if memos.count != 0 {
            memo.id = memos.max(ofProperty: "id")! + 1
        }
        memoViewController.setupDate(selectedMemo: memo)
        navigationController?.pushViewController(memoViewController, animated: true)
        
    }
    
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! MemoTableViewCell
        
        cell.setupViews(title: memoArray[indexPath.row].title, date: memoArray[indexPath.row].date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoViewController = storyboard?.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        memoViewController.setupDate(selectedMemo: memoArray[indexPath.row])
        navigationController?.pushViewController(memoViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        108
    }
}
