//
//  AppDelegate.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/10/30.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var spolightBooks:[Book]?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        let mainVC = MainViewController()
        let navc = UINavigationController(rootViewController: mainVC)
        navc.navigationBar.isTranslucent = false
        window?.rootViewController = navc
        window?.makeKeyAndVisible()
        
        if #available(iOS 9.0, *) {
            self.setupShortCut()
            self.setupSpotlight()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    // 3DTouch ShortCut
    @available (iOS 9.0, *)
    func setupShortCut() {
        let icon1 = UIApplicationShortcutIcon(type: .pause)
        let item1 = UIApplicationShortcutItem(type: "timer", localizedTitle: "计时器", localizedSubtitle: nil, icon: icon1, userInfo: ["key":"timer"])
        let icon2 = UIApplicationShortcutIcon(type: .play)
        let item2 = UIApplicationShortcutItem(type: "videoPlayer", localizedTitle: "视频播放器", localizedSubtitle: nil, icon: icon2, userInfo: ["key":"video"])
        let icon3 = UIApplicationShortcutIcon(type: .location)
        let item3 = UIApplicationShortcutItem(type: "location", localizedTitle: "定位服务", localizedSubtitle: nil, icon: icon3, userInfo: ["key":"location"])
        let icon4 = UIApplicationShortcutIcon(type: .add)
        let item4 = UIApplicationShortcutItem(type: "3DTouch", localizedTitle: "3DTouch", localizedSubtitle: nil, icon: icon4, userInfo: ["key":"3DTouch"])
        UIApplication.shared.shortcutItems = [item1,item2,item3,item4]
    }
    
    // Spotlight
    @available(iOS 9.0, *)
    func setupSpotlight() {
        
        guard let path = Bundle.main.path(forResource: "books", ofType: "plist") else {
            return
        }
        
        var books:[Book] = []
        if let originData = NSArray(contentsOfFile: path) as? Array<[String:String]> {
            for data in originData {
                books.append(Book(dictionary: data))
            }
        }
        spolightBooks = books
        
        var items:[CSSearchableItem] = []
        for book in spolightBooks! {
            
            if let id = book.spolightid {
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: "book")
                attributeSet.title = book.title
                attributeSet.contentDescription = book.des
                attributeSet.thumbnailData = (book.cover != nil) ? UIImageJPEGRepresentation(UIImage(named: "\(book.cover!).jpg")!, 1.0) : nil
                
                if let spolightKey = book.spolightKey {
                    let keys = spolightKey.components(separatedBy: "|")
                    attributeSet.keywords = keys
                }
                
                //每一个CSSearchableItem的uniqueIdentifier必须唯一
                let item = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "book_domain", attributeSet: attributeSet)
                
                items.append(item)
            }
        }

        CSSearchableIndex.default().indexSearchableItems(items) {
            (error) in
            if error != nil {
                print("Spolight注册失败：\(error!.localizedDescription)")
            } else {
                print("Spolight注册成功")
            }
        }
    }
}

extension AppDelegate {
    //ShortCut
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let key = shortcutItem.userInfo!["key"] as! String
        
        var demos:[Dictionary<String, String>]?
        let path = Bundle.main.path(forResource: "demoList", ofType: "plist")
        if path != nil{
            if let content = NSArray(contentsOfFile:path!) {
                demos = content as? [Dictionary<String, String>]
            }
        }
        
        var business:String?
        var title:String?
        
        
        if let demos = demos, demos.count > 0 {
            for demo:[String: String] in demos {
                if demo[DEMO_KEY] == key {
                    business = demo[DEME_BUSINESS]
                    title = demo[DEMO_ITEM]
                    break
                }
            }
        }
        
        guard let _ = business else {
            completionHandler(true)
            return
        }
        
        let navc = window?.rootViewController as! UINavigationController
        
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        guard let ns = nameSpace as? String else{
            assert(false, "无法获取命名空间")
            return
        }
        let aClass: AnyClass? = NSClassFromString("\(ns).\(business!)")
        guard let classType = aClass as? UIViewController.Type else {
            return
        }
        let vc = classType.init()
        vc.title = title ?? ""
        
        if navc.viewControllers.count > 1 {
            navc.popToRootViewController(animated: false)
        }
        navc.show(vc, sender: nil)
        
        completionHandler(true)
    }
    
    //Spolight
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if userActivity.userInfo != nil, let identifier = userActivity.userInfo!["kCSSearchableItemActivityIdentifier"] as? String  {
            if spolightBooks == nil {
                guard let path = Bundle.main.path(forResource: "books", ofType: "plist") else {
                    return true
                }
                var books:[Book] = []
                if let originData = NSArray(contentsOfFile: path) as? Array<[String:String]> {
                    for data in originData {
                        books.append(Book(dictionary: data))
                    }
                }
                spolightBooks = books
            }
            
            for book in spolightBooks! {
                if let spolightid = book.spolightid, spolightid == identifier {
                    let bookDetailVC = BookDetailViewController(bookInfo: book)
                    
                    let navc = self.window?.rootViewController as! UINavigationController
                    if navc.topViewController != navc.viewControllers.first {
                        navc.popToRootViewController(animated: true)
                    }
                    navc.pushViewController(bookDetailVC, animated: true)
                    break
                }
            }
        }
        return true
    }
}
