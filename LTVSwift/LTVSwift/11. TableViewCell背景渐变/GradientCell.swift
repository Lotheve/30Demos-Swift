//
//  GradientCell.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/9.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class GradientCell: UITableViewCell {
    
    var cellIndex:Int?
    var totalIndex:Int?
    var beginColor:UIColor?
    var endColor:UIColor?

    override func draw(_ rect: CGRect) {
        
        guard let cellIndex = cellIndex, cellIndex >= 0, let totalIndex = totalIndex, totalIndex > 0, cellIndex < totalIndex, let beginColor = beginColor, let endColor = endColor else {
            return
        }
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        //颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //渐变位置数组
        let locations = [0, 1] as [CGFloat]
        //颜色数组
        let colors = [beginColor.cgColor, endColor.cgColor]
        //创建渐变对象
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            return
        }
        //轴线起点
        let start = CGPoint(x: 0, y: -(CGFloat(cellIndex) * self.bounds.height))
        //轴线终点
        let end = CGPoint(x: self.bounds.width, y: CGFloat(totalIndex - cellIndex) * self.bounds.height)
        //绘制
        ctx.drawLinearGradient(gradient, start: start, end: end, options: [])
    }
}
