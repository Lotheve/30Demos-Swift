//
//  BookListViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/29.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let CELL_HEIGHT:CGFloat = 88

class BookListViewController: BaseViewController {
    lazy var tableMain: UITableView = {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAVI_BAR_HEIGHT)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        table.rowHeight = CELL_HEIGHT
        table.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: BookCellID)
        return table
    }()
    
    var books:[Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.view.addSubview(tableMain)
    }
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "books", ofType: "plist") else {
            return
        }
        if let originData = NSArray(contentsOfFile: path) as? Array<[String:String]> {
            for data in originData {
                books.append(Book(dictionary: data))
            }
        }
    }
}

extension BookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCellID) as! BookCell
        
        let book = books[indexPath.row]
        if book.cover != nil {
            cell.bookImageView.image = UIImage(named: "\(book.cover!).jpg")
        }
        cell.titleLabel.text = book.title
        cell.priceLabel.text = (book.price != nil) ? "¥\(book.price!)" : "待定"
        cell.descriptionLabel.text = book.des ?? "暂无描述"
        return cell
    }
}

extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let book = books[indexPath.row]
        let bookDetailVC = BookDetailViewController(bookInfo: book)
        self.show(bookDetailVC, sender: nil)
        
    }
}
