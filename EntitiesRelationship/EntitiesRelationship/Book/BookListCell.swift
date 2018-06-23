//
//  BookListCell.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit

class BookListCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var borrowDateLabel: UILabel!
    @IBOutlet weak var lendingDaysLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    
    func setModel(model:Book) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let name = model.name {
            self.nameLabel.text = "书名: " + "《\(name)》"
        } else {
            self.nameLabel.text = "书名: 暂无"
        }
        if model.price != 0 {
            self.priceLabel.text = "价格: " + "\(model.price) /天"
        } else {
            self.priceLabel.text = "价格: 暂无"
        }
        if let borrowDate = model.borrowDate {
            let nowDate = Date()
            let calendar = NSCalendar(identifier: NSCalendar.Identifier.chinese)
            //时间间隔
            let component = calendar?.components(NSCalendar.Unit.day, from: borrowDate, to: nowDate, options: NSCalendar.Options(rawValue: kCFCalendarComponentsWrap))
            //间隔天数
            let lending = component?.day
            //借阅日期
            let borrow = formatter.string(from: borrowDate)
            self.borrowDateLabel.text = borrow
            //间隔
            self.lendingDaysLabel.text = "\(lending!) 天"
            //借阅费
            if model.price != 0 && lending != 0 {
                self.amountPayableLabel.text = "\(Float(lending!) * model.price) 元"
            } else {
                self.amountPayableLabel.text = "金额不详"
            }
        } else {
            self.borrowDateLabel.text = "日期不详"
            self.lendingDaysLabel.text = "天数不详"
            self.amountPayableLabel.text = "金额不详"
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
