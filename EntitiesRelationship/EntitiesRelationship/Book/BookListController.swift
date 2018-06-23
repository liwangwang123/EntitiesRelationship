//
//  BookListController.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit

class BookListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //根据学生model 查找 book 数据,从学生列表界面传过来
    var student: Student?
    var indexPath: IndexPath?
    
    //数据数组
    var dataSource = [Book]()
    //选中的需要删除的数据数组
    var deleteSource = [Book]()
    //全选和删除按钮辅助 view
    var handle: BookHandle?
    //是否需要全选 cell
    var isAllSelected = true//是否全选
    
    var tableView: UITableView?
    let cellIdentifier = "BookListCell"
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addRightItem()
        
        //获取数据
        let save = SaveInfo()
        dataSource = save.queryBookInfo(name: (student?.name!)!) as! [Book]
        
        addTableView()
    }
    
    func addRightItem() {
        let item = UIBarButtonItem(title: "编辑", style:  UIBarButtonItemStyle.plain, target: self, action: #selector(addEditingAction))
        self.navigationItem.rightBarButtonItem = item
    }
    
    //编辑状态更改
    @objc func addEditingAction() {
        self.tableView?.setEditing(!(self.tableView?.isEditing)!, animated: true)
        let item = self.navigationItem.rightBarButtonItem
        item?.title = (self.tableView?.isEditing)! ? "完成" : "编辑"
        addBookHandle()
        var frame = handle?.frame
        frame?.origin.y = (self.tableView?.isEditing)! ? ScreenHeight - 114 : ScreenHeight
        handle?.frame = frame!
    }
    
    // MARK: tableView
    func addTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.allowsMultipleSelectionDuringEditing = true
        tableView?.register(UINib.init(nibName: "BookListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookListCell
        cell.setModel(model: dataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //把选中的 cell 对应的 model 放在deleteSource数组中
        deleteSource.append(dataSource[indexPath.row])
        //如果两个数组的数量一样,就表明现在是全选状态
        if deleteSource.count == dataSource.count {
            isAllSelected = false
        }
        print("\(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        //取消选中,移除deleteSource中的 model
        for num in 0..<deleteSource.count {
            let item = deleteSource[num]
            if item.name == model.name {
                deleteSource.remove(at: num)
                isAllSelected = true
                //每次只能点击一个 cell, 只能移除一个 model,找到需要移除的 model 之后,后面的就不需要遍历了,因为数组的数量发生了变化,特别是在移除元素的时候,很容易发生数组越界
                return
            }
        }
        print("\(indexPath)")
    }
    
    func addBookHandle() {
        if handle == nil {
            handle = BookHandle(frame: CGRect(x: 0, y: ScreenWidth, width: ScreenWidth, height: 80))
            handle?.checkAllButton.addTarget(self, action: #selector(checkAllAction), for: .touchUpInside)
            handle?.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
            self.view.addSubview(handle!)
        }
    }
    
    //cell全选处理
    @objc func checkAllAction() {
        if isAllSelected { //全选
            for num in 0..<dataSource.count {
                let index = IndexPath(item: num, section: 0)
                self.tableView?.selectRow(at: index, animated: true, scrollPosition: UITableViewScrollPosition.bottom)
            }
            deleteSource.removeAll()
            deleteSource = dataSource
        } else {//全不选
            for num in 0..<dataSource.count {
                let index = IndexPath(item: num, section: 0)
                self.tableView?.deselectRow(at: index, animated: true)
            }
            deleteSource.removeAll()
        }
        isAllSelected = !isAllSelected
    }
    
    //删除
    @objc func deleteAction() {
        // 需要移除deleteSource中的元素,同时还要清除数据库数据
        var deleteBookNames = [String]()
        for item in deleteSource {
            deleteBookNames.append(item.name!)
        }
        let save = SaveInfo()
        if deleteBookNames.count == dataSource.count {
            let isSuccess = save.deleteStudentInfo((student?.name)!)
            if isSuccess {
                print("删除学生成功")
                //这个通知应该放在 SaveInfo 类里的 deleteStudentInfo 方法中比较好,放在这里是因为,在返回上一个界面的时候,需要刷新界面,直接删除一个 cell 比刷新整个界面(可能有很多条)节省内存
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotification.Name.DeleteStudentNotificationName), object: indexPath, userInfo: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let isSuccess = save.deleteBooks(studentName: (student?.name)!, booksName: deleteBookNames)
            if isSuccess {
                print("删除成功, 更新界面")
                deleteSource.removeAll()
                dataSource = save.queryBookInfo(name: (student?.name!)!) as! [Book]
                self.tableView?.reloadData()
            }
        }
    }
    
    /*
     // MARK: 左滑 cell 添加按钮
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: " 删除") { (rowAction, indexPath) in
            print("点击删除")
        }
        let editing = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "编辑") { (rowAction, indexPath) in
            print("点击编辑")
        }

        return [deleteAction, editing]
    }
     */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("销毁控制器:\(self)")
    }
}
