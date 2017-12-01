//
//  Book.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/29.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class Book: NSObject {
    
    @objc var title: String?
    @objc var author: String?
    @objc var des: String?
    @objc var cover: String?
    @objc var price: String?
    @objc var press: String?
    @objc var intro: String?
    @objc var spolightKeys: Array<String>?
    
    init(dictionary: [String: String]) {
        super.init()
        for (key, value) in dictionary {
            if let modelKey = map(key: key) {
                setValue(value, forKey: modelKey)
            }
        }
    }
    
    func map(key: String) -> String? {
        let mapList = [
            "title": "title",
            "author": "author",
            "image": "cover",
            "description": "des",
            "price": "price",
            "press": "press",
            "intro": "intro",
            "spolightKeys" : "spolightKeys"
        ]
        return mapList[key]
    }
}
