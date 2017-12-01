//
//  BookListViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/29.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*
 资料参考：http://swift.gg/2015/09/11/custom_search_bar_tutorial/
 */

import UIKit

fileprivate let CELL_HEIGHT:CGFloat = 88

class BookListViewController: BaseViewController {
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "书名/作者/出版社"
        searchController.searchBar.showsCancelButton = false
        
        return searchController
    }()
    
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
        table.tableHeaderView = searchController.searchBar
        return table
    }()
    
    var books:[Book] = []
    var filterBooks:[Book]?
    
    enum SearchMode {
        case end
        case ready
        case search
    }
    var searchMode: SearchMode = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.view.addSubview(tableMain)
        
        // 不设置true会有一堆问题
        self.definesPresentationContext = true
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
        if searchMode == .search {
            return filterBooks?.count ?? 0
        }
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchMode == .search ? ((filterBooks != nil) ? filterBooks!.count : 0) > indexPath.row : books.count > indexPath.row {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: BookCellID) as! BookCell
            
            var book:Book
            if searchMode == .search {
                book = filterBooks![indexPath.row]
            } else {
                book = books[indexPath.row]
            }
            
            if book.cover != nil {
                cell.bookImageView.image = UIImage(named: "\(book.cover!).jpg")
            }
            cell.titleLabel.text = book.title
            cell.priceLabel.text = (book.price != nil) ? "¥\(book.price!)" : "待定"
            cell.descriptionLabel.text = book.des ?? "暂无描述"
            return cell
        }
        
        return UITableViewCell()
    }
}

extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchMode == .search ? ((filterBooks != nil) ? filterBooks!.count : 0) > indexPath.row : books.count > indexPath.row {
            let book = books[indexPath.row]
            let bookDetailVC = BookDetailViewController(bookInfo: book)
            self.show(bookDetailVC, sender: nil)
        }
    }
}

extension BookListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
            
        filterBooks = books.filter { (book) -> Bool in
            
            if let bookTitle = book.title {
                if bookTitle.localizedCaseInsensitiveContains(searchText) {return true}
            }
            if let bookAuthor = book.author {
                if bookAuthor.localizedCaseInsensitiveContains(searchText) {return true}
            }
            if let bookPress = book.press {
                if bookPress.localizedCaseInsensitiveContains(searchText) {return true}
            }
            return false
        }
        self.tableMain.reloadData()
    }
}

extension BookListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text?.count == 0 {
            searchMode = .ready
        } else {
            searchMode = .search
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text?.count == 0 {
            searchMode = .ready
        } else {
            searchMode = .search
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchMode = .end
    }
}

extension BookListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        var frame = tableMain.frame
        frame.size.height += NAVI_BAR_HEIGHT
        tableMain.frame = frame
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        var frame = tableMain.frame
        frame.size.height -= NAVI_BAR_HEIGHT
        tableMain.frame = frame
    }
}
