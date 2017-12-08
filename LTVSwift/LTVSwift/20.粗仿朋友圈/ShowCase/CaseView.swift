//
//  CaseView.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let image_space:CGFloat = 20

class CaseView: UIView {
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, image_space)
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        collectionView.register(UINib.init(nibName: "CaseCell", bundle: nil), forCellWithReuseIdentifier: CaseCellID)
        return collectionView
    }()
    
    var images:[String]?
    var curIndex:Int = 0
    
    
    convenience init(frame: CGRect, images: [String], curIndex: Int) {
        self.init(frame: frame)
        self.images = images
        self.curIndex = curIndex
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGesture()
        
        self.initializeUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
}

extension CaseView {
    func initializeUI() {
        self.backgroundColor = UIColor.black
        self.layer.masksToBounds = true
        
        var rect = self.bounds
        rect.size.width += image_space
        collectionView.frame = rect
        
        self.addSubview(collectionView)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.curIndex), at: UICollectionViewScrollPosition.left, animated: false)
        }
    }
}

extension CaseView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseCellID, for: indexPath) as! CaseCell
        let imageName = self.images![indexPath.section]
        if let image = UIImage(named: imageName) {
            cell.imageView.image = image
        }
        return cell
    }
}
