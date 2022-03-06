//
//  Memo.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/05.
//

import RealmSwift

class Memo: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = Date()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
