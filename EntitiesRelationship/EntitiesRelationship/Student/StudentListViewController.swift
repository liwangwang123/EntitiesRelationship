//
//  StudentListViewController.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//  通过cell左滑删除 cell

import UIKit

class StudentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataSource = [Any]()
    
    var tableView: UITableView?
    let cellIdentifier = "StudentListCell"
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let save = SaveInfo()
        dataSource = save.queryStudentInfo()
        addTableView()
        
        //删除一个 student 下的所有数据,会
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NSNotification.Name.DeleteStudentNotificationName), object: nil, queue: OperationQueue(), using: { (notification) in
            DispatchQueue.main.async {
                let indexPath = notification.object as! IndexPath
                self.dataSource.remove(at: indexPath.row)
                self.tableView?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
        })
    }
    
    // MARK: tableView
    func addTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib.init(nibName: "StudentListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StudentListCell
        cell.setModel(model: dataSource[indexPath.row] as! Student)
        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let book = BookListController()
        book.student = dataSource[indexPath.row] as? Student
        book.indexPath = indexPath
        self.navigationController?.pushViewController(book, animated: true)
        print("\(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "删除") { (rowAction, indexPath) in
            let student = self.dataSource[indexPath.row] as! Student
            let save = SaveInfo()
            let isSuccess = save.deleteStudentInfo(student.name!)
            if isSuccess {
                print("删除学生成功")
                self.dataSource.remove(at: indexPath.row)
                self.tableView?.reloadData()
            }
        }
        return [deleteAction]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    deinit {
        print("销毁控制器:\(self)")
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
