//
//  CaseCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let CaseCellID = "CaseCell"

class CaseCell: UICollectionViewCell {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
    }
}
