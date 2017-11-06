//
//  TimerController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/1.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class TimerController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    enum TimerStatus {
        case ready
        case on
        case end
    }
    
    var status:TimerStatus = .ready {
        willSet(aStatus){
            self.configMeteringButton(withStauts: aStatus)
        }
    }
    
    var timer:Timer?
    var beginTime:TimeInterval = 0
    var currentTime:TimeInterval = 0
    var timeDuration:TimeInterval = 0

    var times:[String] = []
    
    @IBOutlet var circleView: UIView!
    
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var millisecondLabel: UILabel!
    
    
    @IBOutlet var meteringButton: UIButton!
    @IBOutlet var operateButton: UIButton!
    
    @IBOutlet var tableMain: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        self.tableMain.register(UINib.init(nibName: "TimerCell", bundle: nil), forCellReuseIdentifier: "TimerCellID")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil && (timer?.isValid)! {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func configUI() {

        self.circleView.layer.cornerRadius = self.circleView.bounds.size.width/2.0
        self.circleView.layer.borderWidth = 3.0
        self.circleView.layer.borderColor = UIColor.white.cgColor
        self.circleView.backgroundColor = UIColor.clear
        
        self.meteringButton.layer.cornerRadius = floor(self.meteringButton.bounds.size.width/2.0)
        self.operateButton.layer.cornerRadius = floor(self.operateButton.bounds.size.width/2.0)

        self.operateButton.setTitle("开始", for: .normal)
        self.operateButton.setTitle("停止", for: .selected)
        self.status = .ready

        self.refreshTimeWithDuration(timeDuration)
    }
    
    func configMeteringButton(withStauts status:TimerStatus){
        switch status {
        case .ready:
            self.meteringButton.setTitle("计次", for: .normal)
            self.meteringButton.isEnabled = false
        case .on:
            self.meteringButton.setTitle("计次", for: .normal)
            self.meteringButton.isEnabled = true
        case .end:
            self.meteringButton.setTitle("复位", for: .normal)
            self.meteringButton.isEnabled = true
        }
    }
    
    func calculateTime(_ duration:TimeInterval) -> (minutes:Int,seconds:Int,millSeconds:Int) {
        let timeAmount:Int = duration > 0 ? Int(duration * 1000) : 0
        let minutes = timeAmount/60000
        let seconds = (timeAmount - minutes * 60000)/1000
        let millSeconds = (timeAmount - minutes * 60000 - seconds * 1000)/10 //显示两位 因此/10
        return (minutes:minutes,seconds:seconds,millSeconds:millSeconds)
    }
    
    func refreshTimeWithDuration(_ duration:TimeInterval) {
        let time = self.calculateTime(duration)
        self.secondLabel.text = (time.minutes < 10 ? "0\(time.minutes)":"\(time.minutes)") + ":" + (time.seconds < 10 ? "0\(time.seconds)":"\(time.seconds)")
        self.millisecondLabel.text = time.millSeconds < 10 ? "0\(time.millSeconds)":"\(time.millSeconds)"
    }
    

    //MARK: - Action
    @IBAction func actionMetering(_ sender: UIButton) {
        switch status {
        case .ready:
            break
        case .on:
            // 计次
            let time = calculateTime(timeDuration + CACurrentMediaTime()-beginTime)
            self.times.insert((time.minutes < 10 ? "0\(time.minutes)":"\(time.minutes)")+":"+(time.seconds < 10 ? "0\(time.seconds)":"\(time.seconds)")+":"+(time.millSeconds < 10 ? "0\(time.millSeconds)":"\(time.millSeconds)"), at: 0)
            self.tableMain.reloadData()
        case .end:
            // 复位
            status = .ready
            timeDuration = 0
            times.removeAll()
            self.refreshTimeWithDuration(0)
            self.tableMain.reloadData()
        }
    }
    
    @IBAction func actionOperate(_ sender: UIButton) {
        switch status{
        case .ready,.end:
            self.operateButton.isSelected = true
            status = .on
            // 开始计时
            beginTime = CACurrentMediaTime()
            timer = Timer.init(timeInterval: 0.01, target: self, selector: #selector(timerRepet), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            
        case .on:
            self.operateButton.isSelected = false
            status = .end
            //结束计时
            if let _ = timer {
                timer?.invalidate(
                )
                timer = nil
            }
            timeDuration += CACurrentMediaTime()-beginTime
            beginTime = 0
            currentTime = 0
        }
    }
    
    @objc func timerRepet() {
        currentTime = CACurrentMediaTime()
        let duration:TimeInterval = currentTime-beginTime
        self.refreshTimeWithDuration(timeDuration + duration)
    }
    
    //MARK: - delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if times.count > indexPath.row {
            let cell:TimerCell = tableView.dequeueReusableCell(withIdentifier: "TimerCellID") as! TimerCell
            cell.contentView.backgroundColor = UIColor.white
            cell.labelLogo.text = "\(times.count-indexPath.row)"
            cell.labelTime.text = times[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - Other
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
