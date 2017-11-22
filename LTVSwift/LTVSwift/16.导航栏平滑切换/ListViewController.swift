//
//  ListViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let CELLID = "ListCellID"

class ListViewController: BaseViewController {
    
    lazy var tableMain: UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        table.rowHeight = 80
        table.register(UITableViewCell.self, forCellReuseIdentifier: CELLID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableMain)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLID)
        cell?.selectionStyle = .none
        cell?.textLabel?.text = "滑动有惊喜"
        return cell!
    }
}
