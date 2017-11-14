//
//  ParticleAnimationController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/13.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class ParticleAnimationController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "bund.png")?.cgImage
        
        DispatchQueue.main.async {
            self.firework()
        }
    }
    
    func firework() {
        
        let fireworkEmitter = CAEmitterLayer()

        //发射源位置
        fireworkEmitter.emitterPosition = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT-200)
        //发射源大小
        fireworkEmitter.emitterSize = CGSize(width: SCREEN_WIDTH/2, height: 0)
        //发射源形状
        fireworkEmitter.emitterShape = kCAEmitterLayerLine
        //发射源模式
        fireworkEmitter.emitterMode = kCAEmitterLayerOutline
        //渲染模式
        fireworkEmitter.renderMode = kCAEmitterLayerAdditive
        
        //rocket粒子
        let rocket = CAEmitterCell()
        rocket.contents = UIImage(named: "rocket.png")?.cgImage
        //生成速率
        rocket.birthRate = 2.0
        //生命周期（此处要与burst的birthRate相关联）
        rocket.lifetime = 1.02
        //发射角度
        rocket.emissionRange = 0 * .pi
        //发射速度
        rocket.velocity = 380
        rocket.velocityRange = 100
        //y方向的加速度分量
        rocket.yAcceleration = 75
        //粒子尺寸及范围
        rocket.scale = 0.2
        rocket.scaleRange = 0.1
        //粒子颜色及范围
        rocket.color = UIColor.red.cgColor
        rocket.redRange = 1.0
        rocket.greenRange = 1.0
        rocket.blueRange = 1.0
        
        //burst粒子（该不可见，在rocket发射即将结束时发射，通过它辅助发射spark）
        let burst = CAEmitterCell()
        //burst粒子的生成速率要跟rocket的lifetime对应，需要保证在rocket生命周期即将结束的时候发射
        burst.birthRate = 1.0
        burst.lifetime = 0.3
        
        //spark粒子
        let spark = CAEmitterCell()
        spark.contents = UIImage(named: "spark.png")?.cgImage
        spark.birthRate = 500
        spark.lifetime = 2.0
        spark.scale = 2.5
        //往任意方向发射
        spark.emissionRange = 2 * .pi
        spark.yAcceleration = 75
        spark.velocity = 120
        
        //缩放比例速度
        spark.scaleSpeed = -0.2
        //颜色变化速度
        spark.redSpeed = -1.5
        spark.blueSpeed = 1.5
        spark.greenRange = 1.0
        spark.alphaSpeed = -0.25
        
        // 组合粒子效果
        // rocket由fireworksEmitter发射
        // burst由rocket发射（在rocket的生命周期内根据birthRate发射）
        // spark由burst发射（在burst的生命周期内根据birthRate发射）
        // 以rocket发射burst为例，burst的color、scale继承自rocket
        fireworkEmitter.emitterCells = [rocket]
        rocket.emitterCells = [burst]
        burst.emitterCells = [spark]
        self.view.layer.addSublayer(fireworkEmitter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


