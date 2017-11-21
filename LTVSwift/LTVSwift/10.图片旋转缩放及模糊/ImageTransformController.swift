//
//  ImageTransformController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/8.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class ImageTransformController: BaseViewController {
    
    var pinchBegintransform:CGAffineTransform = CGAffineTransform.identity
    var rotationBegintransform:CGAffineTransform = CGAffineTransform.identity
    
    var pinchTransform:CGAffineTransform = CGAffineTransform.identity
    var rotationTransform:CGAffineTransform = CGAffineTransform.identity
    
    lazy var pinchGR:UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(actionPinch(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    let originalImage = UIImage(named: "cat.jpg")
    
    lazy var rotationGR:UIRotationGestureRecognizer = {
        let gestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(actionRotation(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    lazy var catView:UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        imageView.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - NAVI_BAR_HEIGHT)/2)
        imageView.backgroundColor = UIColor.lightGray
        imageView.image = originalImage
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(pinchGR)
        imageView.addGestureRecognizer(rotationGR)
        
        return imageView
    }()
    
    lazy var blurView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = catView.bounds
        return view
    }()
    
    lazy var gaussianImage:UIImage = {
        //原始图片
        let inputImage =  CIImage(image: originalImage!)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(10, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: originalImage!.size)
        let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: rect)
        //生成模糊图片
        let image = UIImage(cgImage: cgImage!)
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(catView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    @objc func actionPinch(_ gestureRecognizer:UIGestureRecognizer) {
        
        let gestureRecognizer = gestureRecognizer as! UIPinchGestureRecognizer
        
        switch gestureRecognizer.state {
        case .began:
            pinchBegintransform = pinchTransform
        case .changed:
            pinchTransform = pinchBegintransform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            catView.transform = pinchTransform.concatenating(rotationTransform)
        default:
            break
        }
    }
    
    @objc func actionRotation(_ gestureRecognizer:UIGestureRecognizer) {
        
        let gestureRecognizer = gestureRecognizer as! UIRotationGestureRecognizer
        
        switch gestureRecognizer.state {
        case .began:
            rotationBegintransform = rotationTransform
        case .changed:
            rotationTransform = rotationBegintransform.rotated(by: gestureRecognizer.rotation)
        default:
            break
        }
    }
    
    @IBAction func actionRecover(_ sender: UIButton) {
        catView.transform = CGAffineTransform.identity
        if blurView.superview != nil {
            blurView.removeFromSuperview()
        }
        catView.image = originalImage
    }
    
    //毛玻璃
    @IBAction func actionVisualBlur(_ sender: UIButton) {
        if blurView.superview == nil {
            catView.addSubview(blurView)
        }
    }
    
    //高斯模糊
    @IBAction func actionGaussianBlur(_ sender: UIButton) {
        catView.image = gaussianImage
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == pinchGR && otherGestureRecognizer == rotationGR) || (gestureRecognizer == rotationGR && otherGestureRecognizer == pinchGR) {
            return true
        }
        return false
    }
}
