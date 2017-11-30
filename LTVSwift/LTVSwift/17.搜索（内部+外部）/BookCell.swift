//
//  BookCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/29.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let BookCellID = "BookCell"

class BookCell: UITableViewCell {
    
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
