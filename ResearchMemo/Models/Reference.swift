//
//  Reference.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/03.
//

import RealmSwift

class Reference: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var link = ""
    @objc dynamic var dcCreator = ""
    @objc dynamic var dcPublisher = ""
    @objc dynamic var prismPublicationName = ""
    @objc dynamic var descriptionString = ""
    @objc dynamic var dcDate = ""
    
    override class func primaryKey() -> String? {
        "link"
    }
}
