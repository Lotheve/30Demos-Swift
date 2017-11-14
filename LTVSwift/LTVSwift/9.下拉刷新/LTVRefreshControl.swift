//
//  LTVRefreshControl.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class LTVRefreshControl: UIRefreshControl {
    
    var contentView:RefreshContentView?
    
    var refreshTitle:String? {
        didSet {
            contentView?.refreshLabel.text = refreshTitle
        }
    }

    override init() {
        super.init()
        self.backgroundColor = UIColor.clear  //不设置backgroundColor 高度无法改变
        
        contentView = Bundle.main.loadNibNamed("RefreshContentView", owner: nil, options: nil)?.first as? RefreshContentView
        contentView?.backgroundColor = UIColor.green
        self.addSubview(contentView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = (contentView?.frame)!
        frame.size = self.bounds.size
        contentView?.frame = frame
    }
}
