//
//  VideoPlayerController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/2.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
//import AVFoundation
import AVKit

class VideoPlayerController: BaseViewController {
    
    var playerViewController:AVPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playItem = UIBarButtonItem.init(title: "播放", style: .plain, target: self, action: #selector(actionPlay))
        self.navigationItem.rightBarButtonItem = playItem
        
        //定义一个视频文件路径
        let filePath = Bundle.main.path(forResource: "video", ofType: "mov")
        let videoURL = URL(fileURLWithPath: filePath!)
        let player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
    }
    
    //MARK: - Action
    @objc func actionPlay() {
        if playerViewController != nil {
            self.present(playerViewController!, animated: true) {
                self.playerViewController?.player!.play()
            }
        }
    }
    
    deinit {
        print("VideoPlayerController " + #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
