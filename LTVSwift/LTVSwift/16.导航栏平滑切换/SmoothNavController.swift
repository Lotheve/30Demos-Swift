//
//  SmoothNavController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*
 1.若直接隐藏导航栏，切换过程无法平滑过渡，会产生导航栏的隔断
 2.若设置导航栏透明度为0，导航栏上的按钮也会透明
 3.因此思路是切换过程中逐渐改变导航栏中相关背景视图的透明度，而非整个导航栏
 4.按照这个思路，每个控制器应当有自己的属性控制导航栏透明度，然而同一栈中控制器的导航栏是全局的，因此需要给控制器扩展一个属性记录导航栏的透明度
 */

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
        
        //导航栏非透明（isTranslucent=false）的情况下从屏幕左上角开始布局
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let pushItem = UIBarButtonItem(title: "个人", style: .plain, target: self, action: #selector(actionPush))
        self.navigationItem.rightBarButtonItem = pushItem
        
        self.view.addSubview(tipLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipLabel.frame = CGRect(x: 0, y: NAVI_BAR_HEIGHT, width: self.view.frame.width, height: self.view.frame.height - NAVI_BAR_HEIGHT)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let isPush = self.navigationController?.viewControllers.contains(self), !isPush {
            self.navigationController?.navigationBar.barTintColor = UIColor.white
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
