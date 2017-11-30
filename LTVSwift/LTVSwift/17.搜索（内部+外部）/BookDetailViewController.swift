//
//  BookDetailViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/29.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class BookDetailViewController: BaseViewController {
    
    private let book:Book
    
    @IBOutlet var bookCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var pressLabel: UILabel!
    @IBOutlet var priceLbel: UILabel!
    @IBOutlet var introLabel: UILabel!
    
    init(bookInfo: Book) {
        book = bookInfo
        super.init(nibName: "BookDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = book.title
        
        if book.cover != nil {
            bookCover.image = UIImage(named: "\(book.cover!).jpg")
        }
        titleLabel.text = book.title
        authorLabel.text = book.author
        pressLabel.text = book.press
        priceLbel.text = (book.price != nil) ? "¥ \(book.price!)" : "未知"
        introLabel.text = book.intro
    }
}
