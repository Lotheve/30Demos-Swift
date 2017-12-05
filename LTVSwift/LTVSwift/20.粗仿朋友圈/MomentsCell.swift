//
//  MomentsCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/3.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let MomentsCellID = "MomentsCellID"

fileprivate let edge_margin:CGFloat = 10
fileprivate let item_space:CGFloat = 10

fileprivate let collectionView_rid_width:CGFloat = 56+56

fileprivate let max_length:CGFloat = 140

class MomentsCell: UITableViewCell {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var momentLabel: UILabel!
    @IBOutlet var containerCollectonView: UICollectionView!
    
    @IBOutlet var containerCollectionViewHeight: NSLayoutConstraint!
    
    var item_width:CGFloat = 0
    var item_height:CGFloat = 0
    
    var moment:Moment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        containerCollectionViewHeight.constant = 0
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(edge_margin, edge_margin, edge_margin, edge_margin)
        containerCollectonView.setCollectionViewLayout(layout, animated: true)
        containerCollectonView.delegate = self
        containerCollectonView.dataSource = self
        containerCollectonView.showsVerticalScrollIndicator = false
        containerCollectonView.showsHorizontalScrollIndicator = false
        containerCollectonView.backgroundColor = UIColor.lightGray
        containerCollectonView.register(UINib(nibName: "MomentImageCell", bundle: nil), forCellWithReuseIdentifier: MomentImageCellID)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configWith(moment: Moment) {
        self.reload(withModel: moment)
    }
    
    func reload(withModel moment:Moment) {
        
        self.moment = moment
        
        if let avatarImage = moment.avatar {
            avatar.image = UIImage(named: avatarImage)
        }
        nameLabel.text = moment.nickname
        momentLabel.text = moment.momentContent
        
        self.calculateItemSize()
        self.layoutCollectionView()
        
        self.containerCollectonView.reloadData()
    }
    
    func calculateItemSize() {
        if let images = moment?.images {
            // 无图
            if images.count == 0
            {
                item_width = 0
                item_height = 0
            }
            // 单图
            else if images.count == 1 {
                if let image = UIImage(named: images.first!) {
                    
                    let size = image.size
                    if size.width >= size.height {
                        item_width = max_length
                        item_height = max_length*(size.height/size.width)
                    } else {
                        item_height = max_length
                        item_width = max_length*(size.width/size.height)
                    }
                    
                } else {
                    item_width = 0
                    item_height = 0
                }
            }
            // 多图
            else if images.count > 1 {
                let length = (SCREEN_WIDTH - collectionView_rid_width - 2*edge_margin - 2*item_space) / 3
                item_width = length
                item_height = length
            }
        } else {
            item_width = 0
            item_height = 0
        }
    }
    
    func layoutCollectionView() {
        if let images = moment?.images {
            if images.count == 0 {
                containerCollectionViewHeight.constant = 0
            } else if images.count == 1 {
                if item_height != 0 && item_width != 0 {
                    containerCollectionViewHeight.constant = item_height + 2*edge_margin
                } else {
                    containerCollectionViewHeight.constant = 0
                }
            } else if images.count > 1 {
                let imageCount = images.count <= 9 ? images.count : 9
                let line = (imageCount-1)/3 + 1
                let spaceHeight = CGFloat(line-1)*item_space
                let margin = CGFloat(line)*item_height
                containerCollectionViewHeight.constant = 2*edge_margin + spaceHeight + margin
            }
        }
    }
}

extension MomentsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moment?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let images = moment?.images, images.count > indexPath.row {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentImageCellID, for: indexPath) as! MomentImageCell
            cell.imageView.image = UIImage(named: images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MomentsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: item_width, height: item_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return item_space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return item_space
    }
}
