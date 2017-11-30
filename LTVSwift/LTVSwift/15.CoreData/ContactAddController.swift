//
//  ContactAddController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/16.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

typealias CompletedFunc = (_ contact: ContactModel) -> Void


class ContactAddController: BaseViewController {

    @IBOutlet var avatar: UIImageView!
    @IBOutlet var contactTF: UITextField!
    @IBOutlet var telTF: UITextField!
    @IBOutlet var addButton: UIButton!
    
    enum BusinessType {
        case add
        case update
    }
    
    var businessType = BusinessType.add
    var contact:ContactModel?
    var completion:CompletedFunc?
    
    convenience init(businessType:BusinessType?, contact:ContactModel?, completion: @escaping CompletedFunc) {
        self.init(nibName: "\(type(of: self))", bundle: nil)
        if let businessType = businessType {
            self.businessType = businessType
        }
        self.contact = contact
        self.completion = completion
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEndEditGesture()

        if businessType == .add {
            self.title = "添加联系人"
            self.addButton.setTitle("Add", for: .normal)
        } else {
            self.title = "更新联系信息"
            self.addButton.setTitle("Update", for: .normal)
        }
        
        self.addButton.layer.cornerRadius = 5.0
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius = self.avatar.bounds.width/2.0
        
        if let contact = self.contact {
            if contact.avatar != nil {
                let image = UIImage(data: contact.avatar!)
                self.avatar.image = image
            }
            self.contactTF.text = contact.name
            self.telTF.text = contact.phone
        }
    }
    
    @IBAction func actionSelectAvator(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        if self.contactTF.text == nil || self.contactTF.text?.count == 0 {
            UIAlertView.init(title: nil, message: "name is empty！", delegate: nil, cancelButtonTitle: "got it").show()
            return
        }
        if self.telTF.text == nil || self.telTF.text?.count == 0 {
            UIAlertView.init(title: nil, message: "tel is empty！", delegate: nil, cancelButtonTitle: "got it").show()
            return
        }
        let contact = ContactModel(avatar:UIImagePNGRepresentation(avatar.image!), name: self.contactTF.text, phone: self.telTF.text)
        if self.completion != nil {
            self.completion!(contact)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ContactAddController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.avatar.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
