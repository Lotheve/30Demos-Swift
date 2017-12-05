//
//  Moment.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/4.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import Foundation
import UIKit

struct Moment {
    var nickname:String?
    var avatar:String?
    var momentContent:String?
    var momentImages:String?
    var images:[String]?
    
    
    init(dictionary: [String: Any]) {
        for (key, value) in dictionary {
            if let keypath = map(key:key) {
                self[keyPath:keypath] = value as? String
            }
        }
        if let momentImages = momentImages {
            images = momentImages.components(separatedBy: "|")
        }
    }
    
    func map(key:String) -> WritableKeyPath<Moment, String?>? {
        let mapList = [
            "avatar" : \Moment.avatar,
            "name" : \Moment.nickname,
            "content" : \Moment.momentContent,
            "images" : \Moment.momentImages
        ]
        return mapList[key]
    }
}
