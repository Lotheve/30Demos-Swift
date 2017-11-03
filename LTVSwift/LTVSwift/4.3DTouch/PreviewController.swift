//
//  PreviewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/3.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class PreviewController: BaseViewController {
    
    var label:UILabel?
    var content:String?
    
    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
        
        let action1 = UIPreviewAction.init(title: "点我", style: .default) { (action, viewController) in
            UIAlertView.init(title: nil, message: (viewController as! PreviewController).content!, delegate: nil, cancelButtonTitle: "Okay！").show()
        }
        let action2 = UIPreviewAction.init(title: "别点他", style: .selected) { (action, viewController) in
            UIAlertView.init(title: nil, message: (viewController as! PreviewController).content!, delegate: nil, cancelButtonTitle: "Okay！").show()
        }
        let action3 = UIPreviewAction.init(title: "都退下", style: .destructive) { (action, viewController) in
            UIAlertView.init(title: nil, message: (viewController as! PreviewController).content!, delegate: nil, cancelButtonTitle: "Okay！").show()
        }
        let groupAction = UIPreviewActionGroup.init(title: "Naive", style: .default, actions: [action1,action2,action3])

        return [action1, action2, action3, groupAction]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "预览"
        
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
        label?.backgroundColor = UIColor.white
        label?.textAlignment = .center
        label?.text = "预览界面" + (content ?? "")
        label?.textColor = UIColor.purple
        self.view.addSubview(label!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label?.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
