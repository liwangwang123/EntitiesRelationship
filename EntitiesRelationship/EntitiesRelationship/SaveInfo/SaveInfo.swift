//
//  SaveInfo.swift
//  EntitiesRelationship
//
//  Created by lemo on 2018/6/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit
import CoreData

class SaveInfo: NSObject {
    
    //先查询是否之前借过书,再插入借阅书籍信息
    func insertForInfo(info: Dictionary<String, Any>) {
        let studentId = info["studentId"]
        let bookName = info["book"] as! String
        let borrowDate = info["borrowDate"]
        let price = info["price"]
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "studentId = '\(studentId!)'", "")
        fetch.predicate = predicate
        do {
            let fetchItems = try context.fetch(fetch)
            var isBorrowing = false//是否已订阅
            if fetchItems.count > 0 {
                for item in fetchItems {
                    let item1 = item as! Student
                    let books = item1.books
                    
                    for book in books! {
                        let book1 = book as! Book
                        if book1.name! == bookName {
                             isBorrowing = true
                        }
                    }
                    //当前没有订阅同一本书
                    if isBorrowing == false {
                        let borrowingBook = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
                        borrowingBook.name = bookName
                        borrowingBook.price = Float(price as! String)!
                        borrowingBook.owner = item1
                        borrowingBook.borrowDate = borrowDate as? Date
                        books?.adding(borrowingBook)
                        try context.save()
                    }
                }
            } else {//没有这个学生的解决记录
                //保存学生的信息
                let brrowingStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
                brrowingStudent.name = info["name"] as? String
                brrowingStudent.studentId = studentId as? String
                //保存书籍的信息
                let browingBook = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
                browingBook.name = bookName
                browingBook.price = Float(price as! String)!
                browingBook.borrowDate = borrowDate as? Date
                browingBook.owner = brrowingStudent
                try context.save()
            }
            
        } catch {
            print("查询成功")
        }
    }
    
    // 1. 插入
    //student 与 book -- 一个学生可以有很多本书,一本书只有一个拥有者. 一对多的相对关系.在 CoreData 中设置两者'一对多'和'多对一'关系. 存储时,需要指明两者的相对关系(要不然获取的时候,无法通过其中一个实体获取相关的实体). Student 与 Book 对象会被存储在两个表中. 如果这两个实例是共存亡的关系,在删除的时候,获取'一对多'里的'一',然后遍历'一对多'中的'多',先删除'多',最后删除'一'
    func insert() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print("path\(path!)")
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
        student.name = "小黑"
        student.age = 4
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
        book.name = "白鲸"
        book.price = 19.9
        book.owner = student
        //student.books = NSSet(array: [book])
        do {
            try context.save()
            print("插入成功")
        } catch  {
            print("插入失败")
        }
    }
    
    func insert2() {
        //插入2
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student
        student.name = "大黄"
        student.age = 4
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
        book.name = "白鲸"
        book.price = 15.9
        book.owner = student
        let book1 = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
        book1.name = "家春秋"
        book1.price = 23.5
        book1.owner = student
        student.books = NSSet(array: [book, book1])
        do {
            try context.save()
            print("保存")
        } catch  {
            print("保存失败")
        }
    }
    
    func delete() {
        /*
         如果存储多个有关系的实体,当你删除其中一个实体时,其他实体不会被删除,你需要删除所有关联的实体
         */
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '小黑'", "")
        fetch.predicate = predicate
        do {
            let fetchObjects = try context.fetch(fetch)
            //删除 student 时,需要连同相关的 book 删除,在获取 student 时,先要遍历并删除拥有的 book,最后删除 student
            for student in fetchObjects {
                let stu = student as! Student
                let books = stu.books
                for book in books! {
                    let boo = book as! Book
                    context.delete(boo)
                }
                context.delete(stu)
            }
            try context.save()
            print("删除成功")
        } catch {
            print("删除失败")
        }
    }
    
    //删除学生借的一部分书籍
    func deleteBooks(studentName: String, booksName: [String]) -> Bool {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '\(studentName)'", "")
        fetch.predicate = predicate
        do {
            let fetchItems = try context.fetch(fetch)
            for item in fetchItems {
                let student = item as! Student
                let books = student.books
                var deleteNumer = 0
                for book in books! {
                    let book1 = book as! Book
                    for name in booksName {
                        if book1.name == name {
                            deleteNumer = deleteNumer + 1
                            context.delete(book1)
                        }
                    }
                    if deleteNumer == books?.count {
                        //移除此学生
                        
                    }
                }
                
            }
            try context.save()
            return true
        } catch {
            print("删除失败")
            return false
        }
    }
    
    //删除某个学生的所有借书记录
    func deleteStudentInfo(_ name: String) -> Bool {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '\(name)'", "")
        fetch.predicate = predicate
        do {
            let fetchItems = try context.fetch(fetch)
            for item in fetchItems {
                context.delete(item as! Student)
            }
            try context.save()
            return true
        } catch {
            print("删除失败")
            return false
        }
        
    }
    
    //更改信息
    func modifyInfo() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '毕业小黑'", "")
        fetch.predicate = predicate
        do {
            let fetchObkects = try context.fetch(fetch)
            //获取 student ,更改相关的信息,之后保存
            for student1 in fetchObkects {
                let student = student1 as! Student
                //更改 student 的 books 内容
                let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
                book.name = "家春秋"
                book.price = 32
                book.owner = student
                
                let book1 = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
                book1.name = "世界是平的"
                book1.price = 19.8
                book1.owner = student
        
                student.books?.addingObjects(from: [book, book1])
                try context.save()
            }
            print("更改成功")
        } catch  {
            print("更改失败")
        }
    }
    
    //查询
    func query() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        print("path\(path!)")
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '毕业小黑'", "")
        fetch.predicate = predicate
        let queue = DispatchQueue(label: "info")
        queue.async {
            do {
                let fetchObjects = try context.fetch(fetch)
                var message: String? = nil
                
                for student1 in fetchObjects {
                    let student = student1 as! Student
                    message = "学生:\(student.name!)已经毕业, 需要将借学校的书:"
                    for book1 in student.books! {
                        let book = book1 as! Book
                        message = message! + "《\(book.name!)》"
                    }
                }
                print("\(message!)还给学校")
            } catch {
                print("查询失败")
            }
        }
    }
    
    //查询数据并返回查询到的数据数组
    func queryStudentInfo() -> [Any] {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        /*
         //当需要查询部分信息或者需要根据要求查询时,可以设置查询条件.获取所有的信息时,不需要设置查询条件
         let predicate = NSPredicate(format: "age >= 0", "")
         //也可以用这种方式
         //NSPredicate(format: "age >= %@", "0")
         fetch.predicate = predicate
         */
        do {
            let fetchItems = try context.fetch(fetch)
            if fetchItems.count > 0 {
                print("查询成功")
                return fetchItems
            }
        } catch {
            print("查询失败")
        }
        return []
    }
    
    func queryBookInfo(name: String) -> [Any]{
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "name = '\(name)'", "")
        fetch.predicate = predicate
        do {
            let items = try context.fetch(fetch)
            if items.count > 0 {
                for student1 in items {
                    let student = student1 as! Student
                    let books = student.books
                    return Array(books!)
                    
                }
            }
        } catch {
            print("获取失败")
        }
         return []
    }
    
}
