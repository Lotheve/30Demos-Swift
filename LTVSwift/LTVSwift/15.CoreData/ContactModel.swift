//
//  Contact.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/16.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let entityName = "Contact"

let key_avatar = "avatar"
let key_name = "name"
let key_tel = "tel"

struct ContactModel {
    var avatar:Data?
    var name:String!
    var phone:String!
    
    @available(iOS 10.0, *)
    static func query(withPredicate predicate: NSPredicate?) -> [ContactModel] {
        if let fetchedResults = CoreDataManager.shareManager.query(withEntityName: entityName, predicate: predicate) {
            
            var contacts:[ContactModel] = []
            
            for result in fetchedResults {
                let avatar = result.value(forKey: key_avatar) as? Data
                let name = result.value(forKey: key_name) as? String
                let phone = result.value(forKey: key_tel) as? String
                if let name = name, let phone = phone{
                    let contact = ContactModel.init(avatar: avatar, name: name, phone: phone)
                    contacts.append(contact)
                }
            }
            return contacts
        }else{
            return []
        }
    }
    
    @available(iOS 10.0, *)
    static func queryAll() -> [ContactModel] {
        return self.query(withPredicate: nil)
    }
    
    @available(iOS 10.0, *)
    static func add(contact: ContactModel) {
        
        //获取context
        let managedObectContext = CoreDataManager.shareManager.persistentContainer.viewContext
        //建立Entity对象
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObectContext)
        //新建一个managedObject
        let contactObj = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        contactObj.setValue(contact.avatar, forKey: key_avatar)
        contactObj.setValue(contact.name, forKey: key_name)
        contactObj.setValue(contact.phone, forKey: key_tel)
        //保存数据
        CoreDataManager.shareManager.save()
    }
    
    @available(iOS 10.0, *)
    static func update(contact: ContactModel, withNew newContact: ContactModel) {
        
        //创建谓词
        let name = contact.name
        let tel = contact.phone
        let predicate = NSPredicate(format: "name = %@ AND tel = %@", name!,tel!)
        
        if let fetchedResults = CoreDataManager.shareManager.query(withEntityName: entityName, predicate: predicate) {
            let avatar = newContact.avatar
            let name = newContact.name
            let tel = newContact.phone

            for result in fetchedResults {
                result.setValue(avatar, forKey: key_avatar)
                result.setValue(name, forKey: key_name)
                result.setValue(tel, forKey: key_tel)
            }
        }
        //保存数据
        CoreDataManager.shareManager.save()
    }
    
    @available(iOS 10.0, *)
    static func delete(contact: ContactModel) {
        
        let name = contact.name
        let tel = contact.phone
        let predicate = NSPredicate(format: "name = %@ AND tel = %@", name!,tel!)
        
        if let fetchedResults = CoreDataManager.shareManager.query(withEntityName: entityName, predicate: predicate) {
            for result in fetchedResults {
                CoreDataManager.shareManager.delete(object: result)
            }
        }
        //保存修改
        CoreDataManager.shareManager.save()
    }
}
