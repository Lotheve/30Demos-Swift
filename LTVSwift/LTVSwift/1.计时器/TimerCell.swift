//
//  TimerCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/1.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {

    @IBOutlet var labelLogo: UILabel!
    @IBOutlet var labelItem: UILabel!
    @IBOutlet var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelLogo.backgroundColor = UIColor.clear
        self.labelLogo.layer.cornerRadius = self.labelLogo.bounds.size.width/2.0
        self.labelLogo.layer.borderColor = UIColor.init(red: 71/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1).cgColor
        self.labelLogo.layer.borderWidth = 2.0
        
        self.labelItem.text = "计次"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
