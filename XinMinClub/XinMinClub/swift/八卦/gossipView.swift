//
//  gossipView.swift
//  Home
//
//  Created by 杨科军 on 2016/12/7.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

@objc class gossipView: UIView, UIGestureRecognizerDelegate {

    override init(frame:CGRect) {
        super.init(frame:frame)
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var qianView = UIView()
    private var kunView = UIView()
    private var qianImageView = UIImageView()
    private var kunImageView = UIImageView()
    private var backVw = UIView()
    private var xuImageView = UIImageView()
    private var yinImageView = UIImageView()
    private var yangImageView = UIImageView()
    // MARK:UI界面
    func initView() {
        let x1 = self.frame.size.width
        let y1 = self.frame.size.height
        
        backVw = UIView(frame:CGRect(x:0, y:y1/8, width:x1, height:y1-y1/8))
        backVw.backgroundColor = UIColor.white
        self.addSubview(backVw)
        
        let xuWidth = x1 < (y1-y1/8) ? x1 : (y1-y1/8)
        xuImageView = UIImageView()
        xuImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        xuImageView.center = backVw.center
        xuImageView.image = UIImage(named:"quanbai")
        self.addSubview(xuImageView)
        
        yinImageView = UIImageView()
        yinImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        yinImageView.center = backVw.center
        yinImageView.image = UIImage(named:"yin")
        self.addSubview(yinImageView)
        
        yangImageView = UIImageView()
        yangImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        yangImageView.center = backVw.center
        yangImageView.image = UIImage(named:"yang")
        self.addSubview(yangImageView)
        
        
        qianView = UIView(frame:CGRect(x:0, y:0, width:x1/2, height:y1/8))
        qianView.backgroundColor = UIColor.white
        self.addSubview(qianView)
        kunView = UIView(frame:CGRect(x:x1/2, y:0, width:x1/2, height:y1/8))
        kunView.backgroundColor = UIColor.white
        self.addSubview(kunView)
        
        qianImageView = UIImageView()
        qianImageView.frame = CGRect(x:0, y:0, width:93, height:12)
        qianImageView.center = qianView.center
        qianImageView.image = UIImage(named:"qiangua")
        self.addSubview(qianImageView)
        
        kunImageView = UIImageView()
        kunImageView.frame = CGRect(x:0, y:0, width:93, height:12)
        kunImageView.center = kunView.center
        kunImageView.image = UIImage(named:"kungua")
        self.addSubview(kunImageView)
        
        
        self.stay(line1:qianImageView, line2:kunImageView)
    }
    
    private var line1initalCenter = CGPoint()
    private var line2initalCenter = CGPoint()
    private var qianKaiguan:Bool = false
    private var kunKaiguan:Bool = false
    // MARK:功能
    func stay(line1:UIImageView, line2:UIImageView) {
        //Create can drag lines and binding method
        let pan1 = UIPanGestureRecognizer(target:self, action:#selector(pan1(sender:)))
        pan1.maximumNumberOfTouches = 1
        pan1.maximumNumberOfTouches = 1
        pan1.delegate = self
        line1.isUserInteractionEnabled = true
        line1.addGestureRecognizer(pan1)
        line1initalCenter = line1.center
        
        let pan2 = UIPanGestureRecognizer()
        pan2.addTarget(self, action:#selector(pan2(sender:)))
        line2.isUserInteractionEnabled = true
        line2.addGestureRecognizer(pan2)
        line2initalCenter = line2.center
    }
    
    func pan1(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in:qianImageView)
        
        switch sender.state {
        case .changed:
            qianImageView.center = CGPoint(x:line1initalCenter.x+translation.x, y:line1initalCenter.y+translation.y)
            if backVw.center.x-15<qianImageView.center.x && qianImageView.center.x<backVw.center.x+15 && backVw.center.y-15<qianImageView.center.y && qianImageView.center.y<backVw.center.y+15 {
                UIView.animate(withDuration:0.5, animations: {() -> Void in
                    self.qianImageView.center = self.qianView.center
                    self.qianImageView.isUserInteractionEnabled = false
                    if self.qianKaiguan == false && self.kunKaiguan == false {
                        self.xuImageView.image = UIImage(named:"quanhei")
                        self.qianKaiguan = true
                    }
                    else if self.kunKaiguan == true &&  self.qianKaiguan == false{
                        self.xuImageView.image = UIImage(named:"heile")
                        self.startAnimation()
                        self.disappearView()
                    }
                })
            }
            break

        default:
            UIView.animate(withDuration:0.3, animations: {() -> Void in
                self.qianImageView.center = self.qianView.center
                self.qianImageView.isUserInteractionEnabled = true
            })
            break
        }
    }
    
    func pan2(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in:kunImageView)
        
        switch sender.state {
        case .changed:
            kunImageView.center = CGPoint(x:line2initalCenter.x+translation.x, y:line2initalCenter.y+translation.y)
            if backVw.center.x-15<kunImageView.center.x && kunImageView.center.x<backVw.center.x+15 && backVw.center.y-15<kunImageView.center.y && kunImageView.center.y<backVw.center.y+15 {
                UIView.animate(withDuration:0.5, animations: {() -> Void in
                    self.kunImageView.center = self.qianView.center
                    self.kunImageView.isUserInteractionEnabled = false
                    if self.qianKaiguan == false && self.kunKaiguan == false {
                        self.xuImageView.image = UIImage(named:"banhei")
                        self.kunKaiguan = true
                    }
                    else if self.kunKaiguan == false &&  self.qianKaiguan == true{
                        self.xuImageView.image = UIImage(named:"heile")
                        self.startAnimation()
                        self.disappearView()
                    }
                })
            }
            break
            
        default:
            UIView.animate(withDuration:0.3, animations: {() -> Void in
                self.kunImageView.center = self.kunView.center
                self.kunImageView.isUserInteractionEnabled = true
            })
            break
        }
    }
    
    private var angle:Float = 0
    func startAnimation() {
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.03)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(self.endAnimation))
        let rotationAngle = angle * Float(M_PI)/180.0
        yinImageView.transform = .init(rotationAngle:CGFloat(rotationAngle))
        yangImageView.transform = .init(rotationAngle:CGFloat(rotationAngle))
        UIView.commitAnimations()
    }
    
    func endAnimation() {
        angle -= 5
        if angle <= -365 {
            UIView.animate(withDuration:1, animations: {() -> Void in
                self.yangImageView.center = CGPoint(x:-screenWidth/2, y:self.yangImageView.center.y)
                self.yinImageView.center = CGPoint(x:screenWidth+screenWidth/2, y:self.yinImageView.center.y)
            },completion: {(_ finished: Bool) -> Void in
                // 延时执行
               _ = delaySection.delay(0.5, task: {
                    self.removeFromSuperview()
                })
            })
            return
        }
        self.startAnimation()
    }

    func disappearView() {
        UIView.animate(withDuration:1, animations: {() -> Void in
            self.xuImageView.alpha = 0
            self.qianImageView.alpha = 0
            self.kunImageView.alpha = 0
        })
    }
    
}


