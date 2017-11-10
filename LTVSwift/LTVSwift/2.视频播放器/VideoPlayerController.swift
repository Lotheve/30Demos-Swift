//
//  VideoPlayerController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/2.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerController: BaseViewController {
    
    var playerViewController:AVPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playItem = UIBarButtonItem(title: "播放", style: .plain, target: self, action: #selector(actionPlay))
        self.navigationItem.rightBarButtonItem = playItem
        
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 40)))
        label.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - NAVI_BAR_HEIGHT)/2)
        label.text = "右上角播放本地视频"
        label.textAlignment = .center
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        //定义一个视频文件路径
        if let filePath = Bundle.main.path(forResource: "video", ofType: "mov") {
            let videoURL = URL(fileURLWithPath: filePath)
            let player = AVPlayer(url: videoURL)
            playerViewController = AVPlayerViewController()
            playerViewController?.player = player
        }
    }
    
    //MARK: - Action
    @objc func actionPlay() {
        if playerViewController != nil {
            self.present(playerViewController!, animated: true) {
                self.playerViewController?.player!.play()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
