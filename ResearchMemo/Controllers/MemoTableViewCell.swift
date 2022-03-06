//
//  MemoTableViewCell.swift
//  ResearchMemo
//
//  Created by 岩渕優児 on 2022/03/05.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    func setupViews(title: String, date: Date) {
        titleLabel.text = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
}
