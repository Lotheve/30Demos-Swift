//
//  AddressBookController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/16.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class AddressBookController: BaseViewController {

    var contacts:[ContactModel] = []
    
    lazy var tableMain:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.lightGray
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        table.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: ContactCellID)
        return table
    }()
    
    lazy var remindLabel:UILabel = {
        let label = UILabel()
        label.text = "需要iOS10以上支持"
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))
        
        if #available(iOS 10, *) {
            self.loadData()
            self.view.addSubview(tableMain)
            let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddContact));
            self.navigationItem.rightBarButtonItem = addItem
        }else{
            self.view.addSubview(remindLabel)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if #available(iOS 10, *) {
            tableMain.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }else{
            remindLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
            remindLabel.center = view.center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData(){
        let apple = ContactModel(avatar: UIImagePNGRepresentation(UIImage(named: "apple.png")!), name: "Apple(Chinese)", phone: "400-627-2273")
        let gentleMan = ContactModel(avatar: UIImagePNGRepresentation(UIImage(named: "gentleman.png")!), name: "Lotheve", phone: "18658331225")
        contacts.append(apple)
        contacts.append(gentleMan)
        
        if #available(iOS 10.0, *) {
            let localContacts = ContactModel.queryAll()
            contacts += localContacts
        }
    }
    
    @objc func actionAddContact() {
        let contactAddVC = ContactAddController(businessType: .add, contact: nil) {
            (contact) in
            print(contact)
            if #available(iOS 10.0, *) {
                ContactModel.add(contact: contact)
                self.contacts.append(contact)
                self.tableMain.reloadData()
            }
        }
        self.show(contactAddVC, sender: nil)
    }
}

extension AddressBookController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellID) as! ContactCell
        let contact = contacts[indexPath.row]
        let image = (contact.avatar != nil) ? UIImage(data: contact.avatar!) : UIImage(named: "avatar.png")
        cell.avatar.image = image
        cell.nameLabel.text = contact.name
        cell.phoneLabel.text = contact.phone
        return cell
    }
}

extension AddressBookController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if #available(iOS 10.0, *) {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
                let contact = self.contacts[indexPath.row]
                self.contacts.remove(at: indexPath.row)
                ContactModel.delete(contact: contact)
                self.tableMain.reloadData()
            }
            return [deleteAction]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 10.0, *) {
            tableView.deselectRow(at: indexPath, animated: true)

            let contact = self.contacts[indexPath.row]
            let contactAddVC = ContactAddController(businessType: .update, contact: contact) {
                (contact) in
                print(contact)
                let oldContact = self.contacts[indexPath.row]
                self.contacts[indexPath.row] = contact
                ContactModel.update(contact: oldContact, withNew: contact)
                self.tableMain.reloadRows(at: [indexPath], with: .fade)
            }
            self.show(contactAddVC, sender: nil)
        }
    }
}
