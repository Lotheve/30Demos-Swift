//
//  SmoothNavController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class SmoothNavController: BaseViewController, UINavigationControllerDelegate {
    
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
        
//        // 导航栏非透明（isTranslucent=false）的情况下从屏幕左上角开始布局
//        self.extendedLayoutIncludesOpaqueBars = true
//        self.edgesForExtendedLayout = .top
        
        self.view.backgroundColor = UIColor.white
        self.navBarTintColor = UIColor.purple

        let pushItem = UIBarButtonItem(title: "个人", style: .plain, target: self, action: #selector(actionPush))
        self.navigationItem.rightBarButtonItem = pushItem
        
        self.view.addSubview(tipLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipLabel.frame = CGRect(x: 0, y: NAVI_BAR_HEIGHT, width: self.view.frame.width, height: self.view.frame.height - NAVI_BAR_HEIGHT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let isPush = self.navigationController?.viewControllers.contains(self), !isPush {
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    @objc func actionPush() {
        let personalVC = PersonalViewController(nibName: "PersonalViewController", bundle: nil)
        self.navigationController?.pushViewController(personalVC, animated: true)
    }
}
