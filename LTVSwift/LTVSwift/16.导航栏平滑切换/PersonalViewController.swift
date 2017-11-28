//
//  PersonalViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/20.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let CELLID = "PersonalCellID"
fileprivate let TOP_VIEW_HEIGHT: CGFloat = 280.0
fileprivate let MAX_STRECTH_HEIGHT: CGFloat = 100.0

class PersonalViewController: BaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet var tableMain: UITableView!
    
    @IBOutlet var viewTop: UIView!
    @IBOutlet var imageTop: UIImageView!
    @IBOutlet var imageAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBgAlpha = 0
        self.navBarTintColor = UIColor.purple
        
        if #available(iOS 11, *) {
            self.tableMain.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        let pushItem = UIBarButtonItem(title: "详情", style: .plain, target: self, action: #selector(actionPush))
        self.navigationItem.rightBarButtonItem = pushItem
        
        self.imageAvatar.layer.masksToBounds = true
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.bounds.width/2.0

        self.tableMain.delegate = self
        self.tableMain.dataSource = self
        self.tableMain.tableFooterView = UIView()
        self.tableMain.showsVerticalScrollIndicator = false
        self.tableMain.register(UITableViewCell.self, forCellReuseIdentifier: CELLID)
        
        self.view.addSubview(viewTop)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = self.view.frame
        viewTop.frame = CGRect(x: 0, y: 0, width: frame.width, height: 280)
        tableMain.contentInset = UIEdgeInsetsMake(TOP_VIEW_HEIGHT, 0, 0, 0)
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

extension PersonalViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        if contentOffset.y < -TOP_VIEW_HEIGHT && contentOffset.y > -(TOP_VIEW_HEIGHT + MAX_STRECTH_HEIGHT) {
            var frame = viewTop.frame
            frame.size.height = -contentOffset.y
            viewTop.frame = frame
        } else if contentOffset.y <= -(TOP_VIEW_HEIGHT + MAX_STRECTH_HEIGHT) {
            tableMain.contentOffset = CGPoint(x: 0, y: -(TOP_VIEW_HEIGHT + MAX_STRECTH_HEIGHT))
        }
    }
}
