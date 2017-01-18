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
        
        let xuWidth = x1 < (y1-y1/8) ? x1 : (y1-y1/8)
        xuImageView = UIImageView()
        xuImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        xuImageView.center = backVw.center
        xuImageView.image = UIImage(named:"quanbai")
        
        yinImageView = UIImageView()
        yinImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        yinImageView.center = backVw.center
        yinImageView.image = UIImage(named:"yin")
        
        yangImageView = UIImageView()
        yangImageView.frame = CGRect(x:0, y:0, width:xuWidth, height:xuWidth)
        yangImageView.center = backVw.center
        yangImageView.image = UIImage(named:"yang")
        
        qianView = UIView(frame:CGRect(x:0, y:0, width:x1/2, height:y1/8))
        qianView.backgroundColor = UIColor.white
        kunView = UIView(frame:CGRect(x:x1/2, y:0, width:x1/2, height:y1/8))
        kunView.backgroundColor = UIColor.white
        
        qianImageView = UIImageView()
        qianImageView.frame = CGRect(x:0, y:0, width:x1/2, height:y1/8)
        qianImageView.center = qianView.center
        qianImageView.image = UIImage(named:"qiangua")

        kunImageView = UIImageView()
        kunImageView.frame = CGRect(x:0, y:0, width:x1/2, height:y1/8)
        kunImageView.center = kunView.center
        kunImageView.image = UIImage(named:"kungua")
        
        self.addSubview(backVw)    // 八卦后面的背景
        self.addSubview(qianView)  // 乾卦后面的背景
        self.addSubview(kunView)   // 坤卦后面的背景
        self.addSubview(yangImageView) // 黑色半卦
        self.addSubview(yinImageView)  // 白色半卦
        self.addSubview(xuImageView)   // 虚线图
        
        self.addSubview(kunImageView)  // 坤卦
        self.addSubview(qianImageView) // 乾卦
        
        self.stay(line1:qianImageView, line2:kunImageView)
    }
    
    private var line1initalCenter = CGPoint()
    private var line2initalCenter = CGPoint()
    private var qianKaiguan:Bool = false
    private var kunKaiguan:Bool = false
    // MARK:功能
    func stay(line1:UIImageView, line2:UIImageView) {
        //Create can drag lines and binding method
        let pan1 = UIPanGestureRecognizer()
        pan1.addTarget(self, action:#selector(pan1(sender:)))
        line1.isUserInteractionEnabled = true
        line1.addGestureRecognizer(pan1)
        line1initalCenter = line1.center
        
        let pan2 = UIPanGestureRecognizer()
        pan2.addTarget(self, action:#selector(pan2(sender:)))
        line2.isUserInteractionEnabled = true
        line2.addGestureRecognizer(pan2)
        line2initalCenter = line2.center
    }
    private var isQianGuaCenter:Bool = false
    func pan1(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in:qianImageView)
        
        switch sender.state {
        case .changed:
            qianImageView.center = CGPoint(x:line1initalCenter.x+translation.x, y:line1initalCenter.y+translation.y)
            if isQianGuaCenter {
                return;
            }
            if backVw.center.x-25<qianImageView.center.x && qianImageView.center.x<backVw.center.x+25 && backVw.center.y-25<qianImageView.center.y && qianImageView.center.y<backVw.center.y+25 {
                isQianGuaCenter = true
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
    private var isKunGuaCenter:Bool = false
    func pan2(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in:kunImageView)
        
        switch sender.state {
        case .changed:
            kunImageView.center = CGPoint(x:line2initalCenter.x+translation.x, y:line2initalCenter.y+translation.y)
            if isKunGuaCenter {
                return;
            }
            if backVw.center.x-25<kunImageView.center.x && kunImageView.center.x<backVw.center.x+25 && backVw.center.y-25<kunImageView.center.y && kunImageView.center.y<backVw.center.y+25 {
                isKunGuaCenter = true
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
        angle -= 15
        if angle <= -375 {
            UIView.animate(withDuration:0.8, animations: {() -> Void in
                self.yangImageView.center = CGPoint(x:-screenWidth/2, y:self.yangImageView.center.y)
                self.yinImageView.center = CGPoint(x:screenWidth+screenWidth/2, y:self.yinImageView.center.y)
                self.backVw.isHidden = true    // 八卦后面的背景
                self.qianView.isHidden = true  // 乾卦后面的背景
                self.kunView.isHidden = true   // 坤卦后面的背景
            },completion: {(_ finished: Bool) -> Void in
                // 延时执行
               _ = delaySection.delay(0.2, task: {
                    self.removeFromSuperview()
                })
            })
            return
        }
        self.startAnimation()
    }

    func disappearView() {
        UIView.animate(withDuration:2, animations: {() -> Void in
            self.xuImageView.isHidden = true
            self.qianImageView.isHidden = true
            self.kunImageView.isHidden = true
        })
    }
    
}


