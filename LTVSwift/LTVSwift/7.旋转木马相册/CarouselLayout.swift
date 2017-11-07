//
//  CarouselLayout.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/7.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

fileprivate let item_width = CGFloat(200)
fileprivate let item_height = CGFloat(300)
fileprivate let item_space = CGFloat(30)
fileprivate let transform_sacle = CGFloat(0.75)

class CarouselLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        itemSize = CGSize(width: item_width, height: item_height)
        minimumLineSpacing = CGFloat(item_space)
        let margin = (collectionView!.bounds.width - item_width)/2
        sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attArr = super.layoutAttributesForElements(in: rect)
        let collectionViewWidth = collectionView!.bounds.width

        if let attArr = attArr {
            for cellAtt in attArr {
                
                let offsetX = collectionView!.contentOffset.x
                let cellCenterX = cellAtt.center.x
                let cellDistance = fabs(collectionViewWidth * 0.5 + offsetX - cellCenterX) 
                
                var scale:CGFloat = transform_sacle
                if cellDistance <= collectionViewWidth * 0.5 {
                    scale = (transform_sacle - 1) * cellDistance / collectionViewWidth * 2 + 1
                }
                cellAtt.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return attArr
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let attArr = super.layoutAttributesForElements(in: CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size))
        
        if let attArr = attArr {
            var minimumDistance = CGFloat(MAXFLOAT)
            var proposedContentOffsetX = proposedContentOffset.x
            let collectionViewWidth = collectionView!.bounds.width
            
            for cellAtt in attArr {
                let cellCenterX = cellAtt.center.x
                let cellDistance = collectionViewWidth * 0.5 + proposedContentOffsetX - cellCenterX
                
                if fabs(cellDistance) < fabs(minimumDistance) {
                    minimumDistance = cellDistance
                }
            }
            proposedContentOffsetX -= minimumDistance
            return CGPoint(x: proposedContentOffsetX, y: proposedContentOffset.y)
        }
        return proposedContentOffset
    }
    
}
