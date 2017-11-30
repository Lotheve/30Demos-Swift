//
//  RefreshActionController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class RefreshActionController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var refreshControl:LTVRefreshControl = {
        let refreshCtl = LTVRefreshControl()
        refreshCtl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshCtl.refreshTitle = "飞呀飞呀我的骄傲放纵~"
        return refreshCtl
    }()
    
    lazy var tableMain:UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT)
        table.backgroundColor = UIColor.lightGray
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = UIView();
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        table.addSubview(refreshControl)
        return table
    }()

    @objc func refreshData() {
        //异步模拟数据加载
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.refreshControl.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableMain)
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID") {
            cell.textLabel?.text = "我只是个打酱油的"
            return cell
        }
        return UITableViewCell()
    }
}
