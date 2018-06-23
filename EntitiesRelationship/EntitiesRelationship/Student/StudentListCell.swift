//
//  StudentListCell.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit

class StudentListCell: UITableViewCell {
    
    func setModel(model: Student) {
        if let name = model.name {
            self.nameLabel.text = "姓名: " + name
        } else {
            self.nameLabel.text = "姓名: "
        }
        if let studentId = model.studentId {
            self.studentIdLabel.text = "学号: " + studentId
        } else {
            self.studentIdLabel.text = "学号: "
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
