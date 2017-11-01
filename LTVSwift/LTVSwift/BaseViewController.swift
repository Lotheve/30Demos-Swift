//
//  BaseViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/1.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let leftBarItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action:#selector(actionBack))
        leftBarItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func actionBack() -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
