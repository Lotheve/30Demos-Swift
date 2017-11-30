//
//  ThreeDTouchController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/3.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*
 3D Touch 功能
 一、应用图标捷径（相关代码见AppDelegate）
 二、Peek & Pop
 三、触摸压力感知
 */

import UIKit

class ThreeDTouchController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    var tableMain:LTVTableView?
    
    var abee : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        
        tableMain = LTVTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: UITableViewStyle.plain)
        tableMain?.backgroundColor = UIColor.clear
        tableMain?.delegate = self
        tableMain?.dataSource = self
        tableMain?.tableFooterView = UIView.init()
        self.view.addSubview(tableMain!)
        
        tableMain?.touchWithForce = {
            (force:CGFloat, maxForce:CGFloat) in
            let forceProgress = force/maxForce
            self.view.backgroundColor = UIColor(red: forceProgress, green: forceProgress, blue: forceProgress, alpha: 1)
        }
        tableMain?.touchFinish = {
            self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    

    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "threeDTouchCellID")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "threeDTouchCellID")
        }
        cell?.textLabel?.text = "使劲 别松手"
        cell?.selectionStyle = .none
        
        //注册预览效果
        if #available(iOS 9.0, *) {
            registerForPreviewing(with: self, sourceView: cell!)
        }
        
        return cell!
    }
    
    //MARK: - UIViewControllerPreviewingDelegate
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cell = previewingContext.sourceView as? UITableViewCell
        guard let _ = cell else {
            return nil
        }
        let indexPath = tableMain?.indexPath(for: cell!)
        let vc = PreviewController.init()
        vc.content = "内容" + (indexPath != nil ? "\(indexPath!.row)" : "")
                
        return vc
    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}
