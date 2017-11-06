
//
//  AreaPickerView.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/6.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

let STATE = "state"
let CITIES = "cities"
let CITY = "city"
let AREAS = "areas"


class AreaPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataSource:[[String: AnyObject]]?
    
    var provinces:[String] = []
    var curProvinceIndex = 0

    var cities:[String] = []
    var areas:[String] = []

    var picker:UIPickerView?
    var pickCompletionHandler:((_ picker:AreaPickerView, _ area:String?) -> Void)?
    
    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44 + 216))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadData()
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadData()
        self.configUI()
    }
    
    func loadData() {
        let path = Bundle.main.path(forResource: "area", ofType: "plist")
        if path != nil{
            if let content = NSArray(contentsOfFile:path!) {
                dataSource = content as? [Dictionary<String, AnyObject>]
            }
        }
        if dataSource != nil && dataSource!.count > 0 {
            self.refreshProvince(withProvinces: dataSource, needReload: false)
        }
    }
    
    func configUI() {
        let toolBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 44))
        toolBar.backgroundColor = UIColor.purple
        self.addSubview(toolBar)
        
        let doneButton = UIButton.init(type: .custom)
        doneButton.frame = CGRect.init(x: toolBar.bounds.size.width - 16 - 44, y: 0, width: 44, height: 44)
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitle("完成", for: .normal)
        doneButton.addTarget(self, action: #selector(actionDone), for: .touchUpInside)
        toolBar.addSubview(doneButton)
        
        picker = UIPickerView.init(frame: CGRect.init(x: 0, y: toolBar.bounds.size.height, width: self.bounds.size.width, height: (self.bounds.size.height - toolBar.bounds.size.height) > 0 ? self.bounds.size.height - toolBar.bounds.size.height : 0))
        picker?.backgroundColor = UIColor.white
        picker?.delegate = self
        picker?.dataSource = self
        self.addSubview(picker!)
    }
    
    //MARK: - Private
    func getCities(fromProvinces privinces:[[String: AnyObject]]?, AtIndex index:Int) -> [[String: AnyObject]]? {
        guard let privinces = privinces else {
            return nil
        }
        if index < privinces.count {
            let provinceInfo = privinces[index]
            let cities = provinceInfo[CITIES] as! [[String: AnyObject]]?
            return cities
        }
        return nil
    }
    
    func getAreas(fromCities cities:[[String: AnyObject]]?, AtIndex index:Int) -> [String]? {
        guard let cities = cities else {
            return nil
        }
        if index < cities.count {
            let cityInfo = cities[index]
            let areas = cityInfo[AREAS] as! [String]?
            return areas
        }
        return nil
    }
    
    func refreshProvince(withProvinces provinces:[[String: AnyObject]]?, needReload:Bool) {
        self.provinces.removeAll()
        guard provinces != nil else {
            self.refreshCity(withCities: nil, needReload: needReload)
            return
        }
        for var province in provinces! {
            if let state:String = province[STATE] as? String {
                self.provinces.append(state)
            }
        }
        let cities = self.getCities(fromProvinces: provinces, AtIndex: 0)
        self.refreshCity(withCities: cities,needReload: true)
        if needReload {
            picker?.reloadComponent(0)
            picker?.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func refreshCity(withCities cities:[[String:AnyObject]]?, needReload:Bool) {
        self.cities.removeAll()
        guard cities != nil else {
            self.refreshArea(withAreas: nil,needReload: needReload)
            return
        }
        for var cityInfo in cities! {
            if let cityName = cityInfo[CITY] as? String {
                self.cities.append(cityName)
            }
        }
        let areas = self.getAreas(fromCities: cities, AtIndex: 0)
        self.refreshArea(withAreas: areas,needReload: needReload)
        if needReload {
            picker?.reloadComponent(1)
            picker?.selectRow(0, inComponent: 1, animated: true)
        }
    }
    
    func refreshArea(withAreas areas:[String]?, needReload:Bool) {
        self.areas = areas ?? []
        picker?.reloadComponent(2)
        if needReload {
            self.picker?.reloadComponent(2)
            picker?.selectRow(0, inComponent: 2, animated: true)
        }
    }
    
    func selectProvinces(AtIndex index:Int) {
        let cities = self.getCities(fromProvinces: dataSource, AtIndex: index)
        refreshCity(withCities: cities, needReload: true)
        self.curProvinceIndex = index
    }
    
    func selectCity(AtIndex index:Int) {
        let cities = self.getCities(fromProvinces: dataSource, AtIndex: self.curProvinceIndex)
        guard cities != nil else {
            self.refreshArea(withAreas: nil, needReload: true)
            return
        }
        let areas = self.getAreas(fromCities: cities, AtIndex: index)
        self.refreshArea(withAreas: areas, needReload: true)
    }
    
    //MARK: - Action
    @objc func actionDone() {
        if pickCompletionHandler != nil {
            
            var area:String = ""
            if let provinceIndex = picker?.selectedRow(inComponent: 0), provinceIndex < provinces.count {
                area += provinces[provinceIndex]
            }
            if let cityIndex = picker?.selectedRow(inComponent: 1), cityIndex < cities.count {
                area += cities[cityIndex]
            }
            if let areaIndex = picker?.selectedRow(inComponent: 2), areaIndex < areas.count {
                area += areas[areaIndex]
            }
            pickCompletionHandler!(self, area)
        }
    }
    
    //MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinces.count
        case 1:
            return cities.count
        case 2:
            return areas.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if row < provinces.count {
                return provinces[row]
            }else{
                return ""
            }
        case 1:
            if row < cities.count {
                return cities[row]
            }else{
                return ""
            }
        case 2:
            if row < areas.count {
                return areas[row]
            }else {
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectProvinces(AtIndex: row)
        case 1:
            self.selectCity(AtIndex: row)
        case 2:
            break
        default:
            break
        }
        
    }
}
