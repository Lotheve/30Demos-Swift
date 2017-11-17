//
//  CoreDataManager.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/16.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import Foundation
import CoreData

@available(iOS 10.0, *)
class CoreDataManager: NSObject {
    
    static let shareManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AddressBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private override init() {
        super.init()
    }
    
    //查询操作
    func query(withEntityName entityName:String, predicate:NSPredicate?) -> [NSManagedObject]? {
        //获取context
        let managedObectContext = self.persistentContainer.viewContext
        //建立查询请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        //执行查询请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            return fetchedResults
        } catch  {
            fatalError("数据获取失败")
        }
        return nil
    }
    
    //删除数据
    func delete(object: NSManagedObject) {
        self.persistentContainer.viewContext.delete(object)
    }
    
    //保存更改
    func save() {
        do {
            try self.persistentContainer.viewContext.save()
        } catch  {
            fatalError("无法保存更改")
        }
    }
}

