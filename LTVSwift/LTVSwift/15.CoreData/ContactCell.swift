//
//  ContactCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/16.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let ContactCellID = "ContactCellID"

class ContactCell: UITableViewCell {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.bounds.width/2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
