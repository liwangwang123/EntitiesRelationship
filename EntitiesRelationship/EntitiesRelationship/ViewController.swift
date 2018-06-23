//
//  ViewController.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/19.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var studentIdField: UITextField!
    @IBOutlet weak var bookTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print("path\(path!)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        studentIdField.resignFirstResponder()
        bookTextField.resignFirstResponder()
    }

    @IBAction func saveAction(_ sender: Any) {
        var info = [String: Any]()
        info["name"] = self.nameTextField.text
        info["studentId"] = self.studentIdField.text
        info["book"] = self.bookTextField.text
        let borrowDate = Date(timeIntervalSinceNow: -24 * 60 * 60 * 18)
        info["borrowDate"] = borrowDate
        info["price"] = self.priceTextField.text
        let saveInfo = SaveInfo()
        saveInfo.insertForInfo(info: info)
    }
    @IBAction func returnBook(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }


}

