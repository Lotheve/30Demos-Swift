//
//  SmoothNavController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class SmoothNavController: BaseViewController, UINavigationControllerDelegate {

    var originNavColor:UIColor?
    var originTranslucent:Bool?
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.text = "右上角小手点点，观察导航栏过渡效果"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let pushItem = UIBarButtonItem(title: "个人", style: .plain, target: self, action: #selector(actionPush))
        self.navigationItem.rightBarButtonItem = pushItem
        
        self.view.addSubview(tipLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipLabel.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width-100, height: self.view.frame.height)
        tipLabel.center = self.view.center
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let isPush = self.navigationController?.viewControllers.contains(self), !isPush {
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.tintColor = UIColor.black
        }
    }
    
    @objc func actionPush() {
        let personalVC = PersonalViewController(nibName: "PersonalViewController", bundle: nil)
        self.navigationController?.pushViewController(personalVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
