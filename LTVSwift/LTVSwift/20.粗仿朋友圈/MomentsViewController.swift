//
//  MomentsViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/3.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class MomentsViewController: BaseViewController {
    
    lazy var tableMain:UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        table.register(UINib(nibName: "MomentsCell", bundle: nil), forCellReuseIdentifier: MomentsCellID)
        
        table.estimatedRowHeight = 80.0;
        table.rowHeight = UITableViewAutomaticDimension;
        
        return table
    }()
    
    var moments:[Moment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.view.addSubview(tableMain)
    }
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "Moments", ofType: "plist") else {
            return
        }
        if let originData = NSArray(contentsOfFile: path) as? Array<[String: Any]> {
            for data in originData {
                let moment = Moment(dictionary: data)
                moments.append(moment)
            }
        }
    }
}

extension MomentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MomentsCellID) as! MomentsCell
        let moment = moments[indexPath.row]
        cell.showCaseHandler = {
            images, index in
            if index < images.count {
                let caseview = CaseView(frame: UIScreen.main.bounds, images: images, curIndex: index)
                UIApplication.shared.keyWindow?.addSubview(caseview)
            }
        }
        cell.configWith(moment: moment)
        return cell
    }
}
