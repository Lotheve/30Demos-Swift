//
//  ListViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let CELLID = "ListCellID"
fileprivate let NAV_SHOW_Y:CGFloat = 100.0
fileprivate let NAV_TRANSFORM_HEIGHT:CGFloat = NAVI_BAR_HEIGHT

class ListViewController: BaseViewController {
    
    lazy var tableMain: UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        table.rowHeight = 80
        table.backgroundColor = UIColor.white
        table.register(UITableViewCell.self, forCellReuseIdentifier: CELLID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navBarTintColor = UIColor.purple
        
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

extension ListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        if contentOffset.y >= NAV_SHOW_Y - NAVI_BAR_HEIGHT && contentOffset.y <= NAV_SHOW_Y - NAVI_BAR_HEIGHT + NAV_TRANSFORM_HEIGHT {
            let scale = 1 - (contentOffset.y - (NAV_SHOW_Y - NAVI_BAR_HEIGHT)) / NAV_TRANSFORM_HEIGHT
            print(scale)
            self.navBarBgAlpha = scale
        } else if contentOffset.y > NAV_SHOW_Y - NAVI_BAR_HEIGHT + NAV_TRANSFORM_HEIGHT {
            self.navBarBgAlpha = 0
        } else if contentOffset.y < NAV_SHOW_Y - NAVI_BAR_HEIGHT {
            self.navBarBgAlpha = 1
        }
    }
}
