//
//  GraduateColorController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/4.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class LinearGradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        //颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //渐变位置数组
        let locations = [0, 0.5, 1] as [CGFloat]
        //渐变颜色数组
        let colors = [UIColor.init(red: 0.540, green: 1.000, blue: 0.814, alpha: 1.000).cgColor,
                      UIColor.init(red: 1.000, green: 0.687, blue: 0.695, alpha: 1.000).cgColor,
                      UIColor.init(red: 0.970, green: 1.000, blue: 0.488, alpha: 1.000).cgColor]
        //创建渐变对象
        guard let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            return
        }
        //轴线起点
        let start = CGPoint.zero
        //轴线终点
        let end = CGPoint.init(x: self.bounds.size.width, y: self.bounds.size.height)
        //绘制
        ctx.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)
    }
    
}

class RadialGradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        //颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //渐变位置数组
        let locations = [0, 0.8, 1] as [CGFloat]
        //渐变颜色数组
        let colors = [UIColor.init(red: 0.540, green: 1.000, blue: 0.814, alpha: 1.000).cgColor,
                      UIColor.init(red: 1.000, green: 0.687, blue: 0.695, alpha: 1.000).cgColor,
                      UIColor.init(red: 0.970, green: 1.000, blue: 0.488, alpha: 1.000).cgColor]
        //创建渐变对象
        guard let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            return
        }
        //渐变圆心位置
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        //外圆半径
        let endRadius = min(self.bounds.width, self.bounds.height) / 2
        //内圆半径
        let startRadius:CGFloat = 0

        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
    }
}


class GraduateColorController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
