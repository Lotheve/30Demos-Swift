//
//  BaseViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/1.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let leftBarItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action:#selector(actionBack))
        leftBarItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    @objc func actionBack() -> Void {
        
        if let vcCount = self.navigationController?.viewControllers.count, vcCount > 1 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addEndEditGesture() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func endEdit() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
