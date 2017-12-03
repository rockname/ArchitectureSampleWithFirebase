//
//  ListTableViewCell.swift
//  SampleFirebase
//
//  Created by Yuki Iwana on 2017/12/01.
//  Copyright © 2017年 rockname. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(date: Date, content: String) {
        postDateLabel.text = getString(from: date)
        contentLabel.text = content
    }
    
    private func getString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
