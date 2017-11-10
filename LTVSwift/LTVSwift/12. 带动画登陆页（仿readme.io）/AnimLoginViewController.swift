//
//  AnimLoginViewController.swift
//  LTVSwift
//
//  Created by 卢旭峰 on 2017/11/10.
//  Copyright © 2017年 Lotheve. All rights reserved.
//

import UIKit

class AnimLoginViewController: BaseViewController {
    
    @IBOutlet var accountView: UIView!
    @IBOutlet var passwordView: UIView!
    
    @IBOutlet var accountTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var remindLabel: UILabel!
    
    enum OwlStatus {
        case open
        case close
    }
    
    var owlStatus:OwlStatus = .open {
        willSet (status) {
            guard status != owlStatus else {
                return
            }
            
            switch status {
            case .open:
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.leftUpArm.transform = CGAffineTransform.init(translationX: -10, y: 10)
                    self.rightUpArm.transform = CGAffineTransform.init(translationX: 10, y: 10)
                }, completion: nil)
                UIView.animate(withDuration: 0.15, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.leftDownArm.alpha = 1
                    self.leftUpArm.alpha = 0
                    self.rightDownArm.alpha = 1
                    self.rightUpArm.alpha = 0
                }, completion: {(completed) in
                    self.leftUpArm.transform = CGAffineTransform.identity
                    self.rightUpArm.transform = CGAffineTransform.identity
                })

            case .close:

                self.leftUpArm.transform = CGAffineTransform.init(translationX: -5, y: 5)
                self.rightUpArm.transform = CGAffineTransform.init(translationX: 5, y: 5)
                UIView.animate(withDuration: 0.3, animations: {
                    self.leftDownArm.alpha = 0
                    self.leftUpArm.alpha = 1
                    self.leftDownArm.transform = CGAffineTransform(translationX: 5, y: -5)
                    self.leftUpArm.transform = CGAffineTransform.identity
                    
                    self.rightDownArm.alpha = 0
                    self.rightUpArm.alpha = 1
                    self.rightDownArm.transform = CGAffineTransform(translationX: -5, y: -5)
                    self.rightUpArm.transform = CGAffineTransform.identity
                }, completion: { (completed) in
                    self.leftDownArm.transform = CGAffineTransform.identity
                    self.rightDownArm.transform = CGAffineTransform.identity
                })
            }
        }
    }

    @IBOutlet var leftDownArm: UIImageView!
    @IBOutlet var leftUpArm: UIImageView!
    
    @IBOutlet var rightDownArm: UIImageView!
    @IBOutlet var rightUpArm: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEndEditGesture()
        
        self.leftUpArm.alpha = 0
        self.leftDownArm.alpha = 1
        self.rightUpArm.alpha = 0
        self.leftDownArm.alpha = 1
        
        self.accountView.layer.cornerRadius = 6.0
        self.accountView.layer.borderWidth = 1
        self.accountView.layer.borderColor = UIColor(red: 0xaa/255, green: 0xaa/255, blue: 0xaa/255, alpha: 0.5).cgColor

        self.passwordView.layer.cornerRadius = 6.0
        self.passwordView.layer.borderWidth = 1
        self.passwordView.layer.borderColor = UIColor(red: 0xaa/255, green: 0xaa/255, blue: 0xaa/255, alpha: 0.5).cgColor
        
        self.loginButton.layer.cornerRadius = 6.0
        
        self.entranceAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.remindLabel.text = ""
        self.accountTextfield.text = ""
        self.passwordTextfield.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func entranceAnimate() {
        
        let translationX = self.accountView.frame.minX + self.accountView.frame.width
        let buttonTranslationY = SCREEN_HEIGHT - NAVI_BAR_HEIGHT - self.loginButton.frame.minY
        
        self.accountView.transform = CGAffineTransform(translationX: -translationX, y: 0)
        self.passwordView.transform = CGAffineTransform(translationX: -translationX, y: 0)
        
        self.loginButton.transform = CGAffineTransform(translationX: 0, y: buttonTranslationY)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.accountView.transform = CGAffineTransform.identity
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.passwordView.transform = CGAffineTransform.identity
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.loginButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func remindAnimate() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation")
        let translationX = 5
        shakeAnimation.values = [0, translationX, 0 , -translationX, 0]
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 3
        shakeAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        shakeAnimation.calculationMode = kCAAnimationCubic
        self.remindLabel.layer.add(shakeAnimation, forKey: nil)
    }
    

    @IBAction func passwordDidBeginEditing(_ sender: UITextField) {
        self.owlStatus = .close
    }
    
    @IBAction func passwordDidEndEditing(_ sender: UITextField) {
        self.owlStatus = .open
    }
    
    //MARK: - Actions
    @IBAction func actionLogin(_ sender: UIButton) {
        
        if self.accountTextfield.text == nil || (self.accountTextfield.text?.count)! == 0 {
            self.remindLabel.text = "账号不能为空"
            remindAnimate()
            return
        }
        if self.passwordTextfield.text == nil || (self.passwordTextfield.text?.count)! == 0 {
            self.remindLabel.text = "密码不能为空"
            remindAnimate()
            return
        }
        
        self.accountTextfield.isUserInteractionEnabled = false
        self.passwordTextfield.isUserInteractionEnabled = false
        self.loginButton.isUserInteractionEnabled = false

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let loginSuccessVC = LoginSuccessController()
            self.show(loginSuccessVC, sender: nil)
            self.accountTextfield.isUserInteractionEnabled = true
            self.passwordTextfield.isUserInteractionEnabled = true
            self.loginButton.isUserInteractionEnabled = true
        }
    }
}
