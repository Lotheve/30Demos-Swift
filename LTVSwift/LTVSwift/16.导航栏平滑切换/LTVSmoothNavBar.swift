//
//  LTVSmoothNavBar.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/22.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*
 1.若直接隐藏导航栏，切换过程无法平滑过渡，会产生导航栏的隔断
 2.若设置导航栏透明度为0，导航栏上的按钮也会透明
 3.因此思路是切换过程中逐渐改变导航栏中相关背景视图的透明度，而非整个导航栏
 4.按照这个思路，每个控制器应当有自己的属性控制导航栏透明度，然而同一栈中控制器的导航栏是全局的，因此需要给控制器扩展一个属性navBarBgAlpha记录导航栏的透明度
 5.右划手势返回的过程中，通过hook导航栏控制器的_updateInteractiveTransition方法监听手势滑动，时时修改导航栏背景透明度
 6.手势滑动过程中释放的情况下，导航栏自动复位，上述方法无法调用，会导致复位后导航栏背景透明度保持与手势释放的时刻一致。通过监听交互手势状态修改释放手势后的透明度
 7.通过监听UINavigationBarDelegate中的代理方法shouldPop及shouldPush来修改正常pop及push的导航栏透明度变化
 8.通过给控制器扩展属性navBarTintColor记录导航栏的batTintColor，设置方法及用法同navBarBgAlpha一致
 */

/*
 缺陷：
 目前不支持导航栏为半透明的情况，原因不明
 */

import UIKit

extension UIColor {
    open class var defaultNavBarTintColor: UIColor {
        return UIColor.white
    }
}

extension UIViewController {
    
    fileprivate struct AssociatedKeys {
        static var navBarBgAlpha: CGFloat = 1.0
        static var navBarTintColor: UIColor = UIColor.defaultNavBarTintColor
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
    
    var navBarTintColor: UIColor {
        get {
            if let barTintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor {
                return barTintColor
            } else {
                return UIColor.defaultNavBarTintColor
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navigationBar.barTintColor = newValue
        }
    }
}

extension DispatchQueue {
    
    private static var onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

extension UINavigationController {

    open override func viewDidLoad() {
        UINavigationController.swizzle()
        super.viewDidLoad()
    }
    
    private static let onceToken = UUID().uuidString
    
    class func swizzle() {
        guard self == UINavigationController.self else {
            return
        }
    
        DispatchQueue.once(token: onceToken) {
            let originSelector = NSSelectorFromString("_updateInteractiveTransition:")
            let swizzledSelector = NSSelectorFromString("ltv_updateInteractiveTransition:")
            let originalMethod = class_getInstanceMethod(self, originSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc func ltv_updateInteractiveTransition(_ percentComplete: CGFloat) {
        
        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
            ltv_updateInteractiveTransition(percentComplete)
            return
        }
        
        let fromViewController = coordinator.viewController(forKey: .from)
        let toViewController = coordinator.viewController(forKey: .to)
        
        let fromAlpha = fromViewController?.navBarBgAlpha ?? 0
        let toAlpha = toViewController?.navBarBgAlpha ?? 0
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
        
        // 修改透明度
        setNavigationBarBackground(alpha: newAlpha)
        
        let fromBarTintColor = fromViewController?.navBarTintColor ?? UIColor.defaultNavBarTintColor
        let toBarTintColor = toViewController?.navBarTintColor ?? UIColor.defaultNavBarTintColor
        let newBarTintColor = averageColor(fromColor: fromBarTintColor, toColor: toBarTintColor, percent: percentComplete)
        navigationBar.barTintColor = newBarTintColor
        
        ltv_updateInteractiveTransition(percentComplete)
    }
    
    // 计算进度色值
    private func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
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
            shadowView.isHidden = alpha == 0
        }
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        // 添加手势交互返回过程中对手势状态的的监听
        if let topVC = topViewController, let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }

        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        setNavigationBarBackground(alpha: popToVC.navBarBgAlpha)
        navigationBar.barTintColor = popToVC.navBarTintColor
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        setNavigationBarBackground(alpha: topViewController?.navBarBgAlpha ?? 0)
        navigationBar.barTintColor = topViewController?.navBarTintColor ?? UIColor.defaultNavBarTintColor
        return true
    }
    
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        
        let animations: (UITransitionContextViewControllerKey) -> () = {
            let nowAlpha = context.viewController(forKey: $0)?.navBarBgAlpha ?? 0
            let nowBarTintColor = context.viewController(forKey: $0)?.navBarTintColor ?? UIColor.defaultNavBarTintColor
            self.setNavigationBarBackground(alpha: nowAlpha)
            self.navigationBar.barTintColor = nowBarTintColor
        }
        
        if context.isCancelled {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}
