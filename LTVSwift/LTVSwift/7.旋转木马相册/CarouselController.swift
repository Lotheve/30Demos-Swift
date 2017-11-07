//
//  CarouselController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/7.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class CarouselController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var collectionView:UICollectionView = {
        
        let layout = CarouselLayout()
        let cv = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVI_BAR_HEIGHT), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.lightGray
        cv.dataSource = self
        cv.delegate = self
        cv.register(UINib(nibName: "CarouselCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCellID")
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCellID", for: indexPath) as! CarouselCell
        cell.contentView.backgroundColor = UIColor.white
        cell.imageView.image = UIImage(named: "\(indexPath.row).jpg")
        return cell
    }
}
