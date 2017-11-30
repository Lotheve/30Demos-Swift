//
//  GradientTableController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/9.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class GradientTableController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableMain:UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT)
        table.backgroundColor = UIColor.white
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = 50
        table.sectionFooterHeight = 10
        table.tableFooterView = UIView();
        table.register(GradientCell.self, forCellReuseIdentifier: "GradientCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableMain)
    }

    // MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GradientCell") as? GradientCell {
            
            cell.selectionStyle = .none
            cell.textLabel?.text = "大家好 我美吗"
            
            cell.cellIndex = indexPath.section
            cell.totalIndex = tableView.numberOfSections
            cell.beginColor = UIColor.red
            cell.endColor = UIColor.yellow
            
            return cell
        }
        return UITableViewCell()
    }
}
