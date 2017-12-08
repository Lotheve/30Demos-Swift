//
//  MomentImageCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/5.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let MomentImageCellID = "MomentImageCellID"

class MomentImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }

}
