//
//  LTVTableView.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/3.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class LTVTableView: UITableView {
    
    var touchWithForce:((_ force:CGFloat, _ maxForce:CGFloat) -> Void)?
    var touchFinish:(() -> Void)?
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if #available(iOS 9.0, *) {
            if let touch = touches.first {
                if (touchWithForce != nil) {
                    touchWithForce!(touch.force, touch.maximumPossibleForce)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if #available(iOS 9.0, *) {
            if touchFinish != nil {
                touchFinish!()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if #available(iOS 9.0, *) {
            if touchFinish != nil {
                touchFinish!()
            }
        }
    }

}
