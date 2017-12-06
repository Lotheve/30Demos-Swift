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

fileprivate let collectionView_rid_width:CGFloat = 56+70
fileprivate let item_length:CGFloat = (SCREEN_WIDTH - collectionView_rid_width - 2*item_space)/3

fileprivate let max_length:CGFloat = 140

enum ImageContainerStyle {
    case none
    case single
    case quaternate
    case ennead
}

class MomentsCell: UITableViewCell {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var momentLabel: UILabel!
    @IBOutlet var containerCollectonView: UICollectionView!
    
    @IBOutlet var containerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var containerCollectionViewWidth: NSLayoutConstraint!
    
    var item_width:CGFloat = 0
    var item_height:CGFloat = 0
    
    
    var moment:Moment?
    var images:[UIImage] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        containerCollectionViewHeight.constant = 0
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        containerCollectonView.setCollectionViewLayout(layout, animated: true)
        containerCollectonView.delegate = self
        containerCollectonView.dataSource = self
        containerCollectonView.showsVerticalScrollIndicator = false
        containerCollectonView.showsHorizontalScrollIndicator = false
        containerCollectonView.backgroundColor = UIColor.clear
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

        self.layoutContainerView()
        
        if let images = moment.images {
            for imageName in images {
                let originImage = UIImage(named: imageName)!
                let image = compressImage(originImage, size: CGSize(width: item_width, height: item_height))
                self.images.append(image)
            }
        }
        
        self.containerCollectonView.reloadData()
    }

    func compressImage(_ image:UIImage, size:CGSize) -> UIImage {
        let imageSize = image.size
        let scale = size.width/size.height
        if imageSize.width/imageSize.height == scale
        {
            //等比缩放
            return image.redraw(inRect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), targetSize: size)
        }
        else
        {
            //先裁剪再缩放
            if imageSize.width/imageSize.height > scale
            {
                //水平裁剪
                let width = imageSize.height * scale
                let rect = CGRect(x: imageSize.width-width, y: 0, width: width, height: imageSize.height)
                return image.redraw(inRect: rect, targetSize: size)
            }
            else
            {
                //垂直裁剪
                let height = imageSize.width/scale
                let rect = CGRect(x: 0, y: imageSize.height-height, width: imageSize.width, height: height)
                return image.redraw(inRect: rect, targetSize: size)
            }
        }
    }
    
    func layoutContainerView() {
        if let images = moment?.images {
            if images.count == 0
            {
                self.refreshContainer(withType: .none)
            }
            else if images.count == 1
            {
                self.refreshContainer(withType: .single)
            }
            else if images.count == 4
            {
                self.refreshContainer(withType: .quaternate)
            }
            else
            {
                self.refreshContainer(withType: .ennead)
            }
        }
        else
        {
            self.refreshContainer(withType: .none)
        }
    }
    
    func refreshContainer(withType type:ImageContainerStyle) {
        
        switch type {
        case .none:
            item_width = 0
            item_height = 0
            containerCollectionViewHeight.constant = 0
            containerCollectionViewWidth.constant = 0
            
        case .single:
            let imageName = moment?.images?.first
            let image = UIImage(named: imageName!)
            let size = image!.size
            if size.width >= size.height {
                item_width = max_length
                item_height = max_length*(size.height/size.width)
            } else {
                item_height = max_length
                item_width = max_length*(size.width/size.height)
            }
            containerCollectionViewHeight.constant = item_height
            containerCollectionViewWidth.constant = item_width
            
        case .quaternate:
            item_width = item_length
            item_height = item_length
            
            containerCollectionViewHeight.constant = 2*item_height + item_space
            containerCollectionViewWidth.constant = CGFloat(ceilf(Float(2*item_width + item_space)))

        case .ennead:
            item_width = item_length
            item_height = item_length
            
            let images = (moment?.images)!
            let imageCount = images.count <= 9 ? images.count : 9
            let line = (imageCount-1)/3 + 1
            let spaceHeight = CGFloat(line-1)*item_space
            let itemHeight = CGFloat(line)*item_height
            containerCollectionViewHeight.constant = itemHeight + spaceHeight
            containerCollectionViewWidth.constant = 3*item_width + 2*item_space
        }
    }
}

extension MomentsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moment?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentImageCellID, for: indexPath) as! MomentImageCell
        if let images = moment?.images, images.count > indexPath.row {
            
            cell.imageView.image = UIImage(named: images[indexPath.row])
        }
        return cell
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
