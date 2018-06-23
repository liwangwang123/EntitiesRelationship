//
//  RetureBackController.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit

class ReturnBackController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var bookNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func returnBookAction(_ sender: Any) {
        let name = self.nameLabel.text
        let bookName = self.bookNameLabel.text
        
        let save = SaveInfo()
        let success = save.deleteBooks(studentName: name!, booksName: [bookName!])
        if success {
            print("还书成功")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
