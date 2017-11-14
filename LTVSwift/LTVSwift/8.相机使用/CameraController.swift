//
//  CameraController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: BaseViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playItem = UIBarButtonItem(title: "拍摄", style: .plain, target: self, action: #selector(actionRecord))
        self.navigationItem.rightBarButtonItem = playItem
        
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 40)))
        label.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - NAVI_BAR_HEIGHT)/2)
        label.text = "右上角拍摄照片或视频"
        label.textAlignment = .center
        label.textColor = UIColor.black
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func actionRecord() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "照片", "视频")
        actionSheet.show(in: self.view)
    }
    
    func queryAuthority(withGrantedHandler handler: (() -> Void)?) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .denied, .restricted:
            UIAlertView(title: "提示", message: "请前往设置->隐私->相机 授权应用相机使用权限", delegate: nil, cancelButtonTitle: "Okay！").show()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                granted in
                DispatchQueue.main.async {
                    if granted {
                        if handler != nil {
                            handler!()
                        }
                    }else{
                        
                        UIAlertView(title: "提示", message: "请前往设置->隐私->相机 授权应用相机使用权限", delegate: nil, cancelButtonTitle: "Okay！").show()
                    }
                }
            })
        case .authorized:
            if handler != nil {
                handler!()
            }
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            //照片
            func imagePick() {
                let imagePikcer = UIImagePickerController()
                imagePikcer.sourceType = .camera
                imagePikcer.cameraDevice = .rear
                imagePikcer.mediaTypes = ["public.image"]
                imagePikcer.delegate = self
                self.present(imagePikcer, animated: true, completion: nil)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.queryAuthority(withGrantedHandler: imagePick)
            }else{
                UIAlertView(title: nil, message: "相机不可用", delegate: nil, cancelButtonTitle: "Okay！").show()
            }
        case 2:
            //视频
            func videoPick() {
                let imagePikcer = UIImagePickerController()
                imagePikcer.sourceType = .camera
                imagePikcer.cameraDevice = .rear
                imagePikcer.mediaTypes = ["public.movie"]
                imagePikcer.delegate = self
                self.present(imagePikcer, animated: true, completion: nil)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.queryAuthority(withGrantedHandler: videoPick)
            }else{
                UIAlertView(title: nil, message: "相机不可用", delegate: nil, cancelButtonTitle: "Okay！").show()
            }
        default:
            break
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        switch mediaType {
        case "public.image":
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        case "public.movie":
            if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path ?? "", self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            }
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            UIAlertView(title: nil, message: "视频保存失败", delegate: nil, cancelButtonTitle: "Okay！").show()
            return
        }
        UIAlertView(title: nil, message: "视频已保存到相册", delegate: nil, cancelButtonTitle: "Okay！").show()
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            UIAlertView(title: nil, message: "照片保存失败", delegate: nil, cancelButtonTitle: "Okay！").show()
            return
        }
        UIAlertView(title: nil, message: "照片已保存到相册", delegate: nil, cancelButtonTitle: "Okay！").show()
    }
}
