//
//  LoginSuccessController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/10.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class LoginSuccessController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "你好 雨燕！"

        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 40)))
        label.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - NAVI_BAR_HEIGHT)/2)
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Welcome to Swift!"
        label.textAlignment = .center
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
