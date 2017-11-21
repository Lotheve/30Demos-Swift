//
//  PersonalViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let CELLID = "PersonalCellID"

class PersonalViewController: BaseViewController {
    
    @IBOutlet var tableMain: UITableView!
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var imageTop: UIImageView!
    @IBOutlet var imageAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            self.tableMain.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let pushItem = UIBarButtonItem(title: "详情", style: .plain, target: self, action: #selector(actionPush))
        self.navigationItem.rightBarButtonItem = pushItem
        
        self.view.backgroundColor = UIColor.white
        
        self.imageAvatar.layer.masksToBounds = true
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.bounds.width/2.0

        self.tableMain.delegate = self
        self.tableMain.dataSource = self
        self.tableMain.tableFooterView = UIView()
        self.tableMain.showsVerticalScrollIndicator = false
        self.tableMain.register(UITableViewCell.self, forCellReuseIdentifier: CELLID)
        
        self.view.addSubview(viewTop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = self.view.frame
        viewTop.frame = CGRect(x: 0, y: 0, width: frame.width, height: 280)
        tableMain.contentInset = UIEdgeInsetsMake(280, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func actionPush() {
        let listVC = ListViewController()
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

extension PersonalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLID)
        cell?.textLabel?.text = "头像好看吗"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
}

