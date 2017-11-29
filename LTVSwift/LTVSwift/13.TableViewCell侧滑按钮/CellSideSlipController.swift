//
//  CellSideSlipController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/11.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class CellSideSlipController: BaseViewController {
    
    lazy var tableMain:UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT)
        table.backgroundColor = UIColor.white
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = 50
        table.tableFooterView = UIView();
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        return table
    }()
    
    var dataSource: [(content:String, isMark:Bool)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...5 {
            dataSource.append((content: "划我有惊喜", isMark: false))
        }
        self.view.addSubview(tableMain)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CellSideSlipController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID") {
            if indexPath.row < dataSource.count {
                let item = dataSource[indexPath.row]
                cell.selectionStyle = .none
                cell.textLabel?.text = item.content
                if item.isMark {
                    cell.accessoryType = .checkmark
                }else {
                    cell.accessoryType = .none
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CellSideSlipController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionDelete = UITableViewRowAction(style: .default, title: "删除") { (action, indexPath) in
            self.dataSource.remove(at: indexPath.row)
            self.tableMain.reloadData()
        }
    
        let actionShare = UITableViewRowAction(style: .default, title: "分享") { (action, indexPath) in
            UIAlertView(title: nil, message: "分享成功！", delegate: nil, cancelButtonTitle: "Okay!").show()
        }
        actionShare.backgroundColor = UIColor.lightGray

        let item = self.dataSource[indexPath.row]
        let actionMark = UITableViewRowAction(style: .default, title: item.isMark ? "取消标记" : "标记") { (action, indexPath) in
            var item = self.dataSource[indexPath.row]
            item.isMark = !item.isMark
            self.dataSource[indexPath.row] = item
            self.tableMain.reloadRows(at: [indexPath], with: .fade)
        }
        actionMark.backgroundColor = UIColor.orange

        return [actionDelete, actionShare, actionMark]
    }
}
