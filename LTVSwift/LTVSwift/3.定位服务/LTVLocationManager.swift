//
//  LTVLocationManager.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/2.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
import CoreLocation

class LTVLocationManager: NSObject,CLLocationManagerDelegate {
    
    //单例
    static let shareManager = LTVLocationManager()

    //返回定位坐标的闭包
    var locationFaction:((CLLocationCoordinate2D?) -> Void)?
    //地理编码的闭包
    var cpsNameFaction:((String,String,String) -> Void)?
    
    //Location对象
    lazy var _location:CLLocation = {
        let location = CLLocation()
        return location;
    }();
    //manager对象
    lazy var manager : CLLocationManager = {
        let aManager = CLLocationManager()
        aManager.delegate = self
        aManager.desiredAccuracy = kCLLocationAccuracyBest
        aManager.distanceFilter = kCLDistanceFilterNone
        
        return aManager;
    }();

    private override init() {
        super.init()
    }
    
    func locate() {
        //手机定位是否开启
        let isOpen = CLLocationManager.locationServicesEnabled() as Bool
        if isOpen == false {
            UIAlertView(title:"提示", message:"请先打开手机定位", delegate:nil, cancelButtonTitle: "确定").show()
            return;
        }
        //获取定位服务的授权状态
        let status = CLLocationManager.authorizationStatus()
        //提示授权
        if status == .notDetermined
        {
            if #available(iOS 8.0, *) {
                self.manager.requestWhenInUseAuthorization()
            }
            return
        }
        //拒绝授权
        else if status == .denied || status == .restricted
        {
            UIAlertView(title:"提示", message:"请先授权定位服务", delegate:nil, cancelButtonTitle: "确定").show()
            return;
        }
        self.manager.startUpdatingLocation();
    }
    
    // 地理编码
    class func geocodingWith(geo:String, completionHandler:((_ latitude:CLLocationDegrees?,_ longitude:CLLocationDegrees?) -> Void)?){
        
        CLGeocoder().geocodeAddressString(geo) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil, let placemark = placemarks?.first {
                if completionHandler != nil {
                    let coordinate:CLLocationCoordinate2D? = placemark.location?.coordinate
                    completionHandler!(coordinate?.latitude, coordinate?.longitude)
                }
            }else{
                if completionHandler != nil {
                    completionHandler!(nil, nil)
                }
            }
        }
    }
    
    // 坐标反编码
    class func georecodingWith(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler:((String?) -> Void)?) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude);
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error == nil, let placrmark = placemarks?.first, let placeDetail = placrmark.addressDictionary {
                let place = "\(placeDetail["Country"]!)\(placeDetail["State"]!)\(placeDetail["City"]!)\(placeDetail["SubLocality"]!)\(placeDetail["Name"]!)"
                if completionHandler != nil {
                    completionHandler!(place)
                }
            }else{
                if completionHandler != nil {
                    completionHandler!(nil)
                }
            }
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    //定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation()
        if let location = locations.first {
            if locationFaction != nil {
                locationFaction!(location.coordinate)
            }
        }
    }
    
    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if locationFaction != nil {
            locationFaction!(nil)
        }
    }

}
