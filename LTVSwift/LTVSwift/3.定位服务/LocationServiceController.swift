
//
//  LocationServiceController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/2.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServiceController: BaseViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewContentInsetBottom: NSLayoutConstraint!
    // 定位
    @IBOutlet var locateLongitudeLabel: UILabel!
    @IBOutlet var locateLatitudeLabel: UILabel!
    @IBOutlet var locateGeoLabel: UILabel!
    
    // 坐标反编码
    @IBOutlet var georecodingLongitudeTF: UITextField!
    @IBOutlet var georecodingLatitudeTF: UITextField!
    @IBOutlet var georecodingLocationLabel: UILabel!
    
    // 地理编码
    @IBOutlet var geocodingLocationTF: UITextField!
    @IBOutlet var geocodingLongtitudeLabel: UILabel!
    @IBOutlet var geocodingLatitudeLabel: UILabel!
    
    
    let locationManager = LTVLocationManager.shareManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEndEditGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        locationManager.locationFaction = {
            (coordinate:CLLocationCoordinate2D?) in
            
            if coordinate != nil {
                print("经度:\(coordinate!.longitude)")
                print("纬度:\(coordinate!.latitude)")
                self.locateLongitudeLabel.text = "\(coordinate!.longitude)"
                self.locateLatitudeLabel.text = "\(coordinate!.latitude)"
                //反编码位置
                LTVLocationManager.georecodingWith(latitude: coordinate!.latitude, longitude: coordinate!.longitude, completionHandler: { (place:String?) in
                    if let place = place {
                        self.locateGeoLabel.text = place
                    }
                })
            }else{
                print("定位失败")
                self.locateLongitudeLabel.text = "---"
                self.locateLatitudeLabel.text = "---"
                self.locateGeoLabel.text = "无法获取当前位置"
            }
        }
    }

    //MARK: - Notification
    @objc func keyboardWillShow(_ noti:Notification) {
        
        let userInfo = noti.userInfo
        let keyboardBounds = userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        self.scrollViewContentInsetBottom.constant = keyboardBounds.size.height
    }
    
    @objc func keyboardWillHide(_ noti:Notification) {
        
        self.scrollViewContentInsetBottom.constant = 0
    }
    
    //MARK: - Action
    //定位
    @IBAction func actionLocate(_ sender: UIButton) {
        locationManager.locate()
    }
    
    //坐标反编码
    @IBAction func actionGeorecoding(_ sender: UIButton) {
        guard let longitude = self.georecodingLongitudeTF.text, longitude.count > 0 else {
            UIAlertView(title: "提示", message: "请输入反编码坐标的经度", delegate: nil, cancelButtonTitle: "Okay！").show()
            return
        }
        guard let latitude = self.georecodingLatitudeTF.text, latitude.count > 0 else {
            UIAlertView(title: "提示", message: "请输入反编码坐标的纬度", delegate: nil, cancelButtonTitle: "Okay！").show()
            return
        }
        LTVLocationManager.georecodingWith(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!) { (place) in
            if let place = place {
                self.georecodingLocationLabel.text = place
            }else{
                self.georecodingLocationLabel.text = "无法反编码坐标"
            }
        }
    }
    
    //地理编码
    @IBAction func actionGeocoding(_ sender: UIButton) {
        guard let geo = self.geocodingLocationTF.text, geo.count > 0 else {
            UIAlertView(title: "提示", message: "请输入详细位置", delegate: nil, cancelButtonTitle: "Okay！").show()
            return
        }
        LTVLocationManager.geocodingWith(geo: geo) { (latitude:CLLocationDegrees?, longtitude:CLLocationDegrees?) in
            if let latitude = latitude, let longtitude = longtitude {
                self.geocodingLongtitudeLabel.text = "\(longtitude)"
                self.geocodingLatitudeLabel.text = "\(latitude)"
            }else{
                self.geocodingLongtitudeLabel.text = "未知"
                self.geocodingLatitudeLabel.text = "未知"
            }
        }
    }
}
