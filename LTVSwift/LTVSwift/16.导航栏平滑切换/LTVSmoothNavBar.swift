//
//  LTVSmoothNavBar.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/22.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*
 1. 给控制器增加记录导航栏透明度的属性 navBarBgAlpha
 */

import UIKit

extension UIViewController {
    
    fileprivate struct AssociatedKeys {
        static var navBarBgAlpha: CGFloat = 1.0
    }
    
    var navBarBgAlpha: CGFloat {
        get {
            if let alpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgAlpha) as? CGFloat {
                return alpha
            } else {
                return 1.0 //默认透明度为1
            }
        }
        set {
            var alpha = newValue
            alpha = alpha > 1 ? 1 : alpha
            alpha = alpha < 0 ? 0 : alpha
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgAlpha, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            //设置导航栏透明度
            navigationController?.setNavigationBarBackground(alpha: alpha)
        }
    }
}

extension UINavigationController {
    
    
    
    // 调整导航栏背景视图的透明度
    fileprivate func setNavigationBarBackground(alpha: CGFloat) {
        
        let barBackgroundView = navigationBar.subviews[0]
        let valueForKey = barBackgroundView.value(forKey:)
        
        if navigationBar.isTranslucent {
            if #available(iOS 10.0, *) {
                if let backgroundEffectView = valueForKey("_backgroundEffectView") as? UIView, navigationBar.backgroundImage(for: .default) == nil {
                    backgroundEffectView.alpha = alpha
                }
                
            } else {
                if let adaptiveBackdrop = valueForKey("_adaptiveBackdrop") as? UIView , let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                    backdropEffectView.alpha = alpha
                }
            }
        } else {
            barBackgroundView.alpha = alpha
        }
        
        if let shadowView = valueForKey("_shadowView") as? UIView {
            shadowView.alpha = alpha
        }
    }
}

