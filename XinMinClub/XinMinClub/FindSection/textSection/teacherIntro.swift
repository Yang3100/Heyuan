//
//  teacherIntro.swift
//  course
//
//  Created by 杨科军 on 2016/11/25.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class teacherIntro: UIView {

    private var dict:NSDictionary = [:]
    init(frame:CGRect, teacherData:NSDictionary) {
        super.init(frame:frame)
    
        self.dict = teacherData
        
        self.addSubview(self.backButton)
        self.addSubview(self.teacherIntroView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:UI界面
    private lazy var backButton : UIButton = {
        let bb = UIButton()
        bb.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight)
        bb.backgroundColor = UIColor.white
        bb.alpha = 0.5
        bb.addTarget(self, action:#selector(backButtonAction(sender:)), for:.touchUpInside)
        return bb
    }()
    private lazy var teacherIntroView : UIView = {
        let tiv = UIView()
        tiv.frame = CGRect(x:10, y:0, width:screenWidth-20, height:screenHeight/3)

        let imagev = UIImageView()
        imagev.frame = tiv.bounds
        imagev.image = UIImage(named:"gerenjianjiediban")
        tiv.addSubview(imagev)
        
        let laa = UILabel()
        laa.frame = CGRect(x:8, y:18, width:screenWidth-40, height:20)
        laa.text = "个人简介"
        laa.font = UIFont(name:"Arial", size:15)
        tiv.addSubview(laa)

//        let viv = UIView()
//        viv.frame = CGRect(x:2, y:22, width:screenWidth-24, height:1)
//        viv.backgroundColor = UIColor.gray
//        viv.alpha = 0.5
//        tiv.addSubview(viv)
        
        let imag = UIImageView()
        imag.frame = CGRect(x:10, y:laa.frame.origin.y+30, width:60, height:60)
        let imageString:String = ip + (self.dict.value(forKey:"KC_TITLE_IMG") as? String)!
        let url:URL = URL(string:imageString)!
        imag.sd_setImage(with:url, placeholderImage:teacherIm)
//        imag.image = UIImage(named:"15.jpg")
        tiv.addSubview(imag)
        
        let teTitle = UILabel()
        teTitle.frame = CGRect(x:78, y:13, width:screenWidth-108, height:30)
        teTitle.text = self.dict.value(forKey:"KC_USER") as? String
        tiv.addSubview(teTitle)
        
        let teText = UITextView()
//        teText.isUserInteractionEnabled = false
        teText.isEditable = false
        teText.frame = CGRect(x:78, y:laa.frame.origin.y+30, width:screenWidth-108, height:screenHeight/3-30-10-20)
        teText.text = self.dict.value(forKey:"KC_CONTENT") as! String
//        "1、世界上没有任何东西可以永恒。如果它流动，它就流走;如果它存着，它就干涸;如果它生长，它就慢慢凋零。2、工作上的不如意是正常的，暂时的挫折会很快过去的，有我在支持着你，作你的后盾，还有我们深情伟大的爱，你还怕什么，一切困难都是可以觖决的。3、有遗憾是正常的。人的欲望越大，遗憾就越多，人的欲望越小，遗憾就越少。没有遗憾的人生是糊涂的人生。对遗憾也要作客观的分析，因贪欲过大而遗憾是可悲的，为一点点小事而抱憾终日是不取的。有遗憾说明有追求并有过努力。没有遗憾就无所谓人生的欢乐，没有遗憾也就感觉不到人生的幸福。笑对人生的憾事，人生有遗憾极为正常。4、为什么不能心平气和地生活?关键是没有及时驱赶心中的恶魔。因为心存邪-恶的念头，就不会理智地克制自己，经常会做出悔恨的蠢事。因为时常鬼迷心窍，就会让愚蠢蒙蔽双眼，进入错误的岔道还不知道。因为没有及时清扫心灵的灰尘，意志薄弱者就会不时掉进深潭。5、我知道你现在的麻烦，最好努力使自己暂时忘记它，转移注意力，使自己的思维就会开阔起来。否则一味想着它，反而陷得更深，难以自拔，徒增烦恼!。6、不要认为失去了一切，不要为这点小事而沮丧，成功的路不只一条，重新开始，再来一次，其实，还有很多机会，只要我们能好好的把握住。"
        teText.font = UIFont(name:"Arial", size:14)
        tiv.addSubview(teText)
        
        return tiv
    }()
    //MARK:功能区
    func backButtonAction(sender:UIButton) {
        self.removeFromSuperview()
        courseListViewController.teacherIntroSwitch! = false
    }

}
