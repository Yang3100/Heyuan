//
//  ViewController.swift
//  HeyuanSwfit_11_9
//
//  Created by 赵劲松 on 16/11/9.
//  Copyright © 2016年 赵劲松. All rights reserved.
//

import UIKit

func MY_CGRECT(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)->(CGRect) {
    return CGRect(x:x,y:y,width:width,height:height)
}

class EBookViewController: UIViewController ,UITabBarDelegate {
    
    var brightness = CGFloat()
    var dataView = UIScrollView()
    var buttonView = UIView()
    var navView = UIView()
    var selfTabBar = UIView()
    var textFont:CGFloat = 18
    var titleFont:CGFloat = 30
    var isTap:Bool = false
    var isDark:Bool = false
    var textView = UITextView()
    var nextPage = UIButton()
    var lastPage = UIButton()
    var lightSlider = UISlider()
    var lightView = UIView()
    var setView = UIView()
    var touchView = UIView()
    var backImageView = UIImageView()
    
    var fontView = UIView()
    var fontP = UIButton()
    var fontS = UIButton()
    var fontL = UILabel()
    
    var backView = UIView()
    var backSet1 = UIButton()
    var backSet2 = UIButton()
    var backSet3 = UIButton()
    var backSet4 = UIButton()
    
    var fontSize = 18
    
    var isLightStyle:Bool = true  // 是否为日间模式
    
    private var kj_total:Int = 0  // 章节总数
    private var kj_dict:NSDictionary = [:]  // 接到数据
    private var dictArray:NSArray = []  // 接到数据
    private var isFrist:Bool = true // 判断是第几种获取数据的方式
    
    //单例
    static let shareSingleOne = EBookViewController()

    //MARK:需要传入的数据
    var kj_title:String = ""
    //MARK:获取到数据的方法
    func fristGetData(dict:NSDictionary,thouchNum:Int = 0){  // 第1种
        isFrist = true
        dictArray = [dict]
        kj_total = 1;
        self.kj_num = 0
    }
    func secondGetData(json:NSDictionary, thouchNum:Int = 0){  // 第2种
        isFrist = false
        dictArray = ((json["RET"] as! [String: Any])["Sys_GX_ZJ"] as! NSArray)
        kj_total = dictArray.count
        self.kj_num = thouchNum
    }
    
    //MARK:显示内容之前调用
    var kj_num:Int = 0 {
        willSet {
            
        }
        didSet {
            self.loadDataToView(array:dictArray, Num:kj_num)
        }
    }
    // MARK:加载数据
    func loadDataToView(array:NSArray, Num:Int){
        print(Num)
        kj_dict = array[Num] as! NSDictionary
        // 显示文字
        self.loadText(title:kj_dict["GJ_NAME"] as! String, text:kj_dict["GJ_CONTENT_CN"] as! String)
        let a = DataModel.default()
        let b = kj_dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        a?.addRecentPlay(b)
    }
    
    private func loadText(title:String,text:String){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.firstLineHeadIndent = 4;
        // 字体的行间距
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize:18.0), NSParagraphStyleAttributeName: paragraphStyle]
        let attributedTextString = NSMutableAttributedString(string:text, attributes:attributes)
        // 标题
        let titleAttributes = [NSKernAttributeName:(titleFont/6), NSFontAttributeName:UIFont.systemFont(ofSize:titleFont)] as [String : Any]
        let attributedTitleString = NSMutableAttributedString(string:title + "\n", attributes:titleAttributes)
        attributedTitleString.append(attributedTextString)
        textView.attributedText = attributedTitleString
        if isLightStyle {
            textView.textColor = UIColor(red:68/255.0, green:68/255.0, blue:68/255.0, alpha:1.0)
        }else{
            textView.textColor = UIColor(red:81/255.0, green:133/255.0, blue:203/255.0, alpha:1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        lightSlider.value = Float(UIScreen.main.brightness)
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        brightness = UIScreen.main.brightness
        lightSlider.value = Float(UIScreen.main.brightness)
//        UIScreen.main.brightness = CGFloat(lightSlider.value)
        var image = UIImage.init(named: "喜欢")
        let d = UserDataModel.default()
        if (d?.judgeIsLike(kj_dict["GJ_ID"] as! String))! {
            image = UIImage.init(named: "喜欢了")
        }
        //            image?.renderingMode = UIImageRenderingMode.alwaysOriginal
        let button = self.view.viewWithTag(1+100) as! UIButton
        button.setImage(image, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UIScreen.main.brightness = brightness
    }
    
    func applicationWillResignActive() {
//        UIScreen.main.brightness = brightness
    }
    
    func applicationDidBecomeActive() {
//        brightness = UIScreen.main.brightness
//        UIScreen.main.brightness = CGFloat(lightSlider.value)
    }
    
    func initView() {
        self.initDataView()
        self.initNavBar()
        self.initPageButton()
        self.initTabBar()
    }
    
    func initPageButton() {
        lastPage = UIButton.init(type: .system)
        lastPage.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH / 9,height:SCREEN_HEIGHT/10)
        lastPage.center = CGPoint(x:lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
        lastPage.setTitle("  上  \n  一  \n  章  ", for: .normal)
        lastPage.setTitleColor(.white, for: .normal)
        lastPage.backgroundColor = UIColor.black
        lastPage.alpha = 0.8
        lastPage.tag = 0
        lastPage.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        lastPage.addTarget(self, action:#selector(nextAndOn(sender:)), for:.touchUpInside)
        self.view!.addSubview(lastPage)
        
        nextPage = UIButton.init(type:.system)
        nextPage.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH / 9,height:SCREEN_HEIGHT/10)
        nextPage.center = CGPoint(x:SCREEN_WIDTH-nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
        nextPage.setTitle("  下  \n  一  \n  章  ", for: .normal)
        nextPage.setTitleColor(.white, for: .normal)
        nextPage.backgroundColor = UIColor.black
        nextPage.alpha = 0.8
        nextPage.tag = 1
        nextPage.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        nextPage.addTarget(self, action:#selector(nextAndOn(sender:)), for:.touchUpInside)
        self.view!.addSubview(nextPage)
    }
    
    func initDataView() {
        
        dataView = UIScrollView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
        dataView.backgroundColor = UIColor.clear
        self.view!.addSubview(dataView)
        
        let backImage = UIImage(named:"日间模式")!
        backImageView.image = backImage
        backImageView.frame = CGRect(x:0, y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        dataView.addSubview(backImageView)
        
        textView.frame = CGRect(x:MARGIN+MARGIN/7, y:MARGIN, width:SCREEN_WIDTH-2*MARGIN, height:SCREEN_HEIGHT-2.5*MARGIN)
        textView.textColor = UIColor(red:68/255.0, green:68/255.0, blue:68/255.0, alpha:1.0)
        textView.backgroundColor = UIColor.clear
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        dataView.addSubview(textView)
        
        let tapRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.tapText))
        let longPressRecongnizer = UILongPressGestureRecognizer(target: self, action:#selector(self.longPress))
        textView.addGestureRecognizer(tapRecongnizer)
        textView.addGestureRecognizer(longPressRecongnizer)
    }
    
    func initTabBar() {
        selfTabBar = UIView()
        selfTabBar.frame = CGRect(x:0, y:SCREEN_HEIGHT-49, width:SCREEN_WIDTH, height:49)
        selfTabBar.backgroundColor = UIColor(white:0.0, alpha:0.7)
        self.view.addSubview(selfTabBar)
        let nameA:NSArray = ["目录","喜欢","亮度","夜间","设置"]
        for i in 0..<5{
            let button = UIButton(type:.custom)
            button.frame = CGRect(x:SCREEN_WIDTH/5*CGFloat(i), y:0, width:SCREEN_WIDTH/5, height:49)
            let naImage = UIImage(named:nameA[i] as! String)
            button.setImage(naImage, for:.normal)
            button.tag = i+100
            button.addTarget(self, action:#selector(buttonAction(sender:)), for:.touchUpInside)
            selfTabBar.addSubview(button)
        }
        
        touchView = UIView.init(frame: MY_CGRECT(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(self.touchLightBackground))
        touchView.addGestureRecognizer(ges)
        touchView.isHidden = true
        self.view!.addSubview(touchView)
        
        lightView = UIView.init(frame: MY_CGRECT(x: 0, y: SCREEN_HEIGHT * 7
            / 8 - 49, width: SCREEN_WIDTH, height: SCREEN_HEIGHT / 8))
        lightView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "亮度子页背景")!)
        lightView.alpha = 0
        
        let an = UIImageView.init(frame: MY_CGRECT(x: 0, y: 0, w: 20, h: 20))
        an.image = UIImage.init(named: "亮度左")
        an.center = CGPoint.init(x: 10+an.frame.size.width/2, y: lightView.frame.size.height/2)
        lightView.addSubview(an)
        
        let liang = UIImageView.init(frame: MY_CGRECT(x: 0, y: 0, w: 30, h: 30))
        liang.image = UIImage.init(named: "亮度右")
        liang.center = CGPoint.init(x: screenWidth-10-liang.frame.size.width/2, y: lightView.frame.size.height/2)
        lightView.addSubview(liang)
        
        //TODO: Slider.size修改
        lightSlider = UISlider.init(frame: MY_CGRECT(x: SCREEN_WIDTH / 9, y: SCREEN_HEIGHT / 16.0 - 15, width: SCREEN_WIDTH * 7 / 9, height: 30))
//        lightSlider.backgroundColor = UIColor.blue
//        lightSlider.setThumbImage(self.originImage(image:UIImage(named:"设置")!, size: CGSize(width:20,height:20)), for: .normal)
        lightSlider.addTarget(self, action: #selector(self.controlBright), for: .valueChanged)
        lightSlider.setThumbImage(UIImage.init(named: "圆"), for: .normal)
        lightSlider.setMinimumTrackImage(UIImage.init(named: "liang"), for: .normal)
        lightSlider.setMaximumTrackImage(UIImage.init(named: "hui"), for: .normal)
        lightView.addSubview(lightSlider)
        self.view!.addSubview(lightView)
        
        
        setView.frame = MY_CGRECT(x: 0, y: SCREEN_HEIGHT*4 / 5 - 49, width: SCREEN_WIDTH, height: SCREEN_HEIGHT / 5)
        setView.alpha = 0
        setView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "设置子页背景")!)
        self.view!.addSubview(setView)
        
        fontView = UIView.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth, h: 50))
        
        fontView = UIView.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth, h: 50))
//        fontView.backgroundColor = RED
        setView.addSubview(fontView)
        
        fontP = UIButton.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth / 5, h: 30))
        fontP.setImage(UIImage.init(named: "加"), for: .normal)
        fontP.center = CGPoint.init(x: screenWidth * 9 / 10 - 10, y: 25)
//        fontP.backgroundColor = GREEN
        fontP.addTarget(self, action: #selector(p), for: .touchUpInside)
        fontView.addSubview(fontP)
        
        fontL = UILabel.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth / 10, h: 30))
        fontL.text = "18"
        fontL.textAlignment = NSTextAlignment.center
        fontL.center = CGPoint.init(x: screenWidth * 15 / 20 - 10, y: 25)
//        fontL.backgroundColor = GREEN
        fontL.textColor = LIGHT
        fontView.addSubview(fontL)
        
        let fontF = UILabel.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth / 10 + 5, h: 30))
        fontF.text = "字号:"
        fontF.textAlignment = NSTextAlignment.center
        fontF.center = CGPoint.init(x: screenWidth * 13 / 20 - 10, y: 25)
//        fontF.backgroundColor = GREEN
        fontF.textColor = LIGHT
        fontView.addSubview(fontF)
        
        let fontT = UIImageView.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth / 5, h: 16))
        fontT.center = CGPoint.init(x: screenWidth / 10 + 10, y: 25)
        fontT.image = UIImage.init(named: "字体调节")
        fontView.addSubview(fontT)
        
        fontS = UIButton.init(frame: MY_CGRECT(x: 0, y: 0, w: screenWidth / 5, h: 30))
        fontS.setImage(UIImage.init(named: "减"), for: .normal)
        fontS.contentMode = UIViewContentMode.scaleAspectFill
        fontS.center = CGPoint.init(x: screenWidth * 5 / 10 - 10, y: 25)
//        fontS.backgroundColor = GREEN
        fontS.addTarget(self, action: #selector(s), for: .touchUpInside)
        fontView.addSubview(fontS)
        
        let line = UIView.init(frame: MY_CGRECT(x: 0, y: 49, w: screenWidth, h: 1))
        line.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "分割线")!)
        fontView.addSubview(line)
        
        backView = UIView.init(frame: MY_CGRECT(x: 0, y: 50, w: screenWidth, h:  screenHeight / 5 - 50))
//        backView.backgroundColor = GREEN
        
        let margin = screenWidth * 3 / 7 / 5.0
        
        setView.addSubview(backView)
        
        backSet1 = UIButton.init(frame: MY_CGRECT(x: margin, y: 5, w: screenWidth / 7, h: screenWidth / 7))
        backSet2 = UIButton.init(frame: MY_CGRECT(x: screenWidth / 7 + 2 * margin, y: 5, w: screenWidth / 7, h: screenWidth / 7))
        backSet3 = UIButton.init(frame: MY_CGRECT(x: screenWidth * 2 / 7 + 3*margin, y: 5, w: screenWidth / 7, h: screenWidth / 7))
        backSet4 = UIButton.init(frame: MY_CGRECT(x: screenWidth * 3 / 7 + 4 * margin, y: 5, w: screenWidth / 7, h: screenWidth / 7))
//        backSet1.backgroundColor = DARK
//        backSet2.backgroundColor = DARK
//        backSet3.backgroundColor = DARK
//        backSet4.backgroundColor = DARK
        backSet1.setBackgroundImage(UIImage.init(named: "护眼"), for: .normal)
        backSet2.setBackgroundImage(UIImage.init(named: "日间模式"), for: .normal)
        backSet3.setBackgroundImage(UIImage.init(named: "魅惑"), for: .normal)
        backSet4.setBackgroundImage(UIImage.init(named: "青"), for: .normal)
        backSet1.addTarget(self, action: #selector(setAction1), for: .touchUpInside)
        backSet2.addTarget(self, action: #selector(setAction2), for: .touchUpInside)
        backSet3.addTarget(self, action: #selector(setAction3), for: .touchUpInside)
        backSet4.addTarget(self, action: #selector(setAction4), for: .touchUpInside)
        backView.addSubview(backSet1)
        backView.addSubview(backSet2)
        backView.addSubview(backSet3)
        backView.addSubview(backSet4)
        
        let vMargin = 5 + backSet1.frame.size.height
        let height = backView.frame.size.height
        let lab1 = UILabel.init(frame: MY_CGRECT(x: margin, y: vMargin, w: screenWidth / 7, h: height - vMargin))
        let lab2 = UILabel.init(frame: MY_CGRECT(x: screenWidth / 7 + 2 * margin, y: vMargin, w: screenWidth / 7, h: height - vMargin))
        let lab3 = UILabel.init(frame: MY_CGRECT(x: screenWidth * 2 / 7 + 3*margin, y: vMargin, w: screenWidth / 7, h: height - vMargin))
        let lab4 = UILabel.init(frame: MY_CGRECT(x: screenWidth * 3 / 7 + 4 * margin, y: vMargin, w: screenWidth / 7, h: height - vMargin))
        lab1.text = "护眼"
        lab2.text = "牛皮纸"
        lab3.text = "魅惑"
        lab4.text = "青"
        lab1.textColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 0.7)
        lab2.textColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 0.7)
        lab3.textColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 0.7)
        lab4.textColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 0.7)
        lab1.textAlignment = NSTextAlignment.center
        lab2.textAlignment = NSTextAlignment.center
        lab3.textAlignment = NSTextAlignment.center
        lab4.textAlignment = NSTextAlignment.center
        backView.addSubview(lab1)
        backView.addSubview(lab2)
        backView.addSubview(lab3)
        backView.addSubview(lab4)
        
    }
    
    func p() {
        if fontSize == 28 {
            return
        }
        fontSize += 1
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        fontL.text = NSString.init(format: "%d", fontSize) as String
    }
    
    func s() {
        if fontSize == 15 {
            return
        }
        fontSize -= 1
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        fontL.text = NSString.init(format: "%d", fontSize) as String
    }
    
    func setAction1() {
        let backImage = UIImage(named:"护眼")!
        backImageView.image = backImage
    }
    
    func setAction2() {
        let backImage = UIImage(named:"日间模式")!
        backImageView.image = backImage
    }
    
    func setAction3() {
        let backImage = UIImage(named:"魅惑")!
        backImageView.image = backImage
    }
    
    func setAction4() {
        let backImage = UIImage(named:"青")!
        backImageView.image = backImage
    }
    
    func originImage(image:UIImage,size:CGSize)->(UIImage) {
        UIGraphicsBeginImageContext(size)
        image.draw(in: MY_CGRECT(x: 0, y: 0, width: size.width, height:size.height))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img;
    }
    
    func initNavBar() {
        navView = UIView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:64))
        navView.backgroundColor = UIColor(white:0.0, alpha:0.7)
        self.view.addSubview(navView)
        
        let backImage = UIImage(named:"返回")
        let shareImage = UIImage(named:"分享")
        let gobackNavBar = UIButton(type:.custom)
        gobackNavBar.frame = CGRect(x:10,y:27,width:30,height:30)
        gobackNavBar.setImage(backImage, for:.normal)
        gobackNavBar.addTarget(self, action:#selector(self.clickLeftButton), for:.touchUpInside)
        navView.addSubview(gobackNavBar)
        
        let shareNavBar = UIButton(type:.custom)
        shareNavBar.frame = CGRect(x:screenWidth-40,y:27,width:30,height:30)
        shareNavBar.setImage(shareImage, for:.normal)
        shareNavBar.addTarget(self, action:#selector(self.clickRightButton), for:.touchUpInside)
        navView.addSubview(shareNavBar)
    }
    
    // MARK: Actions
    func buttonAction(sender:UIButton){
        if sender.tag-100==0 {
            let list = ListViewController()
            let animation = CATransition()
            animation.duration = 0.3
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(animation, forKey: nil)
            self.present(list, animated:false, completion:{ (true) in
                list.dataArray = self.dictArray
                list.kj_isLightStyle = self.isLightStyle
            })
        }
        else if sender.tag-100==1 {
            self.like()
        }
        else if sender.tag-100==2 {
            self.popSlider()
        }
        else if sender.tag-100==3 {
            if isLightStyle {
                let riImage = UIImage(named:"日间")
                sender.setImage(riImage, for:.normal)
                self.setReadStyle(style:"夜间")
            }else{
                let riImage = UIImage(named:"夜间")
                sender.setImage(riImage, for:.normal)
                self.setReadStyle(style:"日间")
            }
            isLightStyle = !isLightStyle
        }
        else if sender.tag-100==4 {
            self.popSetView()
        }
    }

    func like() {
        let userModel = UserDataModel.default()
        let b = kj_dict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        let isLike:Bool = (userModel?.addLikeSection(b))!
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        if isLike {
            self.perform(#selector(likeSuccess), with: nil, afterDelay: 0.3)
            let image = UIImage.init(named: "喜欢了")
//            image?.renderingMode = UIImageRenderingMode.alwaysOriginal
            let button = self.view.viewWithTag(1+100) as! UIButton
            button.setImage(image, for: .normal)
        } else {
            self.perform(#selector(closeLikeSuccess), with: nil, afterDelay: 0.3)
            userModel?.deleteLikeSectionID(kj_dict["GJ_ID"] as! String)
            let image = UIImage.init(named: "喜欢")
            //            image?.renderingMode = UIImageRenderingMode.alwaysOriginal
            let button = self.view.viewWithTag(1+100) as! UIButton
            button.setImage(image, for: .normal)
        }
    }
    //    UIImage *image = [[UIImage imageNamed:@"playLiked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    [_likeButton setImage:image forState:UIControlStateNormal];
    //
    
    func likeSuccess() {
        SVProgressHUD.showSuccess(withStatus: "成功!")
        self.perform(#selector(pDismiss), with: nil, afterDelay: 0.5)
    }
    
    func closeLikeSuccess() {
        SVProgressHUD.showSuccess(withStatus: "取消成功!")
        self.perform(#selector(pDismiss), with: nil, afterDelay: 0.5)
    }

    func pDismiss() {
        SVProgressHUD.dismiss()
    }
    
    func longPress() {
        
    }
    
    func controlBright() {
        UIScreen.main.brightness = CGFloat(lightSlider.value)
    }
    
    func touchLightBackground() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.lightView.alpha = 0
            self.setView.alpha = 0
            self.touchView.isHidden = true
        }, completion: { (true) in
            
        })
    }
    
    func tapText() {
        if isTap {
            isTap = false
            DispatchQueue.main.async(execute: {() -> Void in
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    self.navView.frame = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:NAV_HEIGHT+STATUS_HEIGHT)
                    self.selfTabBar.frame = CGRect(x:0, y:SCREEN_HEIGHT-TABBAR_HEIGHT, width:SCREEN_WIDTH, height:TABBAR_HEIGHT)
                    self.nextPage.center = CGPoint(x:SCREEN_WIDTH-self.nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    self.lastPage.center = CGPoint(x:self.lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                }, completion: { (true) in
                    
                })
            })
        }
        else {
            self.isTap = true
            DispatchQueue.main.async(execute: {() -> Void in
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    self.navView.frame = CGRect(x:0, y:-NAV_HEIGHT-STATUS_HEIGHT, width:SCREEN_WIDTH, height:NAV_HEIGHT+STATUS_HEIGHT)
                    self.selfTabBar.frame = CGRect(x:0, y:SCREEN_HEIGHT+TABBAR_HEIGHT, width:SCREEN_WIDTH, height:TABBAR_HEIGHT)
                    self.nextPage.center = CGPoint(x:SCREEN_WIDTH+self.nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    self.lastPage.center = CGPoint(x:-self.lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                }, completion: { (true) in
                    
                })
            })
        }
    }
    
    func clickLeftButton() {
        print("woshis")
        self.dismiss(animated:true, completion:nil)
    }
    
    func clickRightButton() {
        print("nisagho")
        let shareBut = ShareView()
        shareBut.setShareContent = .ShareText
        shareBut.text = "标题:" + (kj_dict["GJ_NAME"] as! String) + "\n\n" + "        " + (kj_dict["GJ_CONTENT_CN"] as! String);
        self.view.addSubview(shareBut)
    }
    
    func clickFirb() {
        
    }
    func popSlider() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.lightView.alpha = 1
        }, completion: { (true) in
            
        })
        self.touchView.isHidden = false
    }
    
    func popSetView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.setView.alpha = 1
        }, completion: { (true) in
            
        })
        self.touchView.isHidden = false
    }
    
    func setReadStyle(style:String="日间"){
        if style=="夜间" {
            backImageView.image = UIImage(named:"夜间背景")
            textView.textColor = UIColor(red:81/255.0, green:133/255.0, blue:203/255.0, alpha:1.0)
            lastPage.alpha = 1.0
            nextPage.alpha = 1.0
            navView.backgroundColor = UIColor(white:0.0, alpha:1.0)
            selfTabBar.backgroundColor = UIColor(white:0.0, alpha:1.0)
        }
        else{
            backImageView.image = UIImage(named:"日间模式")
            textView.textColor = UIColor(red:68/255.0, green:68/255.0, blue:68/255.0, alpha:1.0)
            lastPage.alpha = 0.8
            nextPage.alpha = 0.8
            navView.backgroundColor = UIColor(white:0.0, alpha:0.7)
            selfTabBar.backgroundColor = UIColor(white:0.0, alpha:0.7)
        }
        
    }
    
    func nextAndOn(sender:UIButton){
        if sender.tag==0 {
            if !isFrist {
                if kj_num>0 {
                    self.kj_num -= 1
                }
            }
        }
        else{
            if !isFrist {
                if kj_num<kj_total-1{
                    self.kj_num += 1
                }
            }
        }
    }

    
}

