//
//  DataPickerController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/6.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class DataPickerController: BaseViewController {
    
    @IBOutlet var datePickerTF: UITextField!
    @IBOutlet var areaPickerTF: UITextField!
    
    var datePiker:DatePickerView?
    var areaPicker:AreaPickerView?
    
    var dateFormatter:DateFormatter?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addEndEditGesture()
        
        //日期选择
        dateFormatter = DateFormatter.init()
        dateFormatter?.dateFormat = "yyyy-MM-dd"
        datePiker = DatePickerView()
        datePiker?.pickCompletionHandler = {
            [weak self] picker, date in
            self?.datePickerTF.text = self?.dateFormatter?.string(from: date!)
            self?.datePickerTF.resignFirstResponder()
        }
        datePickerTF.inputView = datePiker!
        
        //地区选择
        areaPicker = AreaPickerView()
        areaPicker?.pickCompletionHandler = {
            [weak self] picker, area in
            self?.areaPickerTF.text = area
            self?.areaPickerTF.resignFirstResponder()
        }
        areaPickerTF?.inputView = areaPicker!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
