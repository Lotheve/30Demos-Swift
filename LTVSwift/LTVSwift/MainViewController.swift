//
//  MainViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/10/30.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataSource:[Dictionary<String, String>]?
    
    lazy var tableMain:UITableView = {
        let table = UITableView.init()
        table.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        table.backgroundColor = UIColor.lightGray
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = UIView.init();
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Swift_30Demo"
        
        let path = Bundle.main.path(forResource: "demoList", ofType: "plist")
        if path != nil{
            if let content = NSArray(contentsOfFile:path!) {
                dataSource = content as? [Dictionary<String, String>]
            }
        }
        self.view.addSubview(tableMain)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = dataSource?.count , indexPath.row < count {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID")!
            cell.contentView.backgroundColor = UIColor.white
            var demoItem:Dictionary<String, String> = dataSource![indexPath.row]
            if let title = demoItem[DEMO_ITEM] {
                cell.textLabel?.text = title
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let count = dataSource?.count , indexPath.row < count {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID")!
            cell.contentView.backgroundColor = UIColor.white
            var demoItem:Dictionary<String, String> = dataSource![indexPath.row]
            if let business = demoItem[DEME_BUSINESS] {
                
                //Swift中，通过字符串获取对应的类，需要将字符串拼接上相应的命名空间
                let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
                guard let ns = nameSpace as? String else{
                    assert(false, "无法获取命名空间")
                    return
                }
                let aClass: AnyClass? = NSClassFromString("\(ns).\(business)")
                guard let classType = aClass as? UIViewController.Type else {
                    return
                }
                let vc = classType.init()
                vc.title = demoItem[DEMO_ITEM]
                self.show(vc, sender: nil)
            }
        }
    }
}
