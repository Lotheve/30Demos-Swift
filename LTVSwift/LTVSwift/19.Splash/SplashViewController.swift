//
//  SplashViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/12/1.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

/*本例splash资源来源于：https://github.com/KobeGong/UberSplash*/

import UIKit
import AVKit

fileprivate let horizontalMargin:CGFloat = 30
fileprivate let verticalMargin:CGFloat = 40
fileprivate let space:CGFloat = 40
fileprivate let buttonHeight:CGFloat = 50

class SplashViewController: BaseViewController {
    
    var player:AVPlayer!
    
    lazy var buttonLogin:UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: horizontalMargin, y: SCREEN_HEIGHT - verticalMargin - buttonHeight , width: (SCREEN_WIDTH - space - horizontalMargin*2)/2, height: buttonHeight)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.setTitle("LOGIN", for: .normal)
        return button
    }()
    lazy var buttonSignup:UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: horizontalMargin + (SCREEN_WIDTH - space - horizontalMargin*2)/2 + space, y: SCREEN_HEIGHT - verticalMargin - buttonHeight , width: (SCREEN_WIDTH - space - horizontalMargin*2)/2, height: buttonHeight)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.setTitle("SIGN UP", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = UIColor.black.cgColor
        self.setupPlayer()
        self.setupButton()
    }
    
    func setupPlayer() {
        
        guard let videoPath = Bundle.main.path(forResource: "welcome_video", ofType: "mp4") else {
            return
        }
        let url = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        self.view.layer.insertSublayer(playerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endedDisplay), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        player.play()
    }
    
    func setupButton() {
        self.view.addSubview(buttonLogin)
        self.view.addSubview(buttonSignup)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func endedDisplay() {
        player.currentItem!.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
