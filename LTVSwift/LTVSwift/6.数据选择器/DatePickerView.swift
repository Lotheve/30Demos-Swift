//
//  DatePickerView.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/6.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    var picker:UIDatePicker?
    var pickCompletionHandler:((_ picker:DatePickerView, _ date:Date?) -> Void)?
    
    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44 + 216))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configUI()
    }
    
    func configUI() {
        
        let toolBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 44))
        toolBar.backgroundColor = UIColor.purple
        self.addSubview(toolBar)
        
        let doneButton = UIButton.init(type: .custom)
        doneButton.frame = CGRect.init(x: toolBar.bounds.size.width - 16 - 44, y: 0, width: 44, height: 44)
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitle("完成", for: .normal)
        doneButton.addTarget(self, action: #selector(actionDone), for: .touchUpInside)
        toolBar.addSubview(doneButton)
        
        picker = UIDatePicker.init(frame: CGRect.init(x: 0, y: toolBar.bounds.size.height, width: self.bounds.size.width, height: (self.bounds.size.height - toolBar.bounds.size.height) > 0 ? self.bounds.size.height - toolBar.bounds.size.height : 0))
        picker?.backgroundColor = UIColor.white
        picker?.locale = Locale(identifier: "zh_CN")
        picker?.datePickerMode = .date
        self.addSubview(picker!)
    }
    
    @objc func actionDone() {
        if pickCompletionHandler != nil {
            pickCompletionHandler!(self, picker?.date)
        }
    }
}
