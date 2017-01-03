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
    var statusView = UIView()
    var navView = UIView()
    var navBar = UINavigationBar()
    var selfTabBar = UITabBar()
    var textFont:CGFloat = 18
    var titleFont:CGFloat = 26
    var isTap:Bool = false
    var isDark:Bool = false
    var textView = UITextView()
    var listView = ListViewController()
    var nextPage = UIButton()
    var lastPage = UIButton()
    var lightSlider = UISlider()
    var lightView = UIView()
    var setView = UIView()
    var touchView = UIView()
    var backImageView = UIImageView()

    var thouchNum:Int = 0   // 接到点击的第几个 自用
    var total:Int = 0  // 章节总数
    var kj_dict:NSDictionary = [:]  // 接到数据
    var kj_title:String = ""
    func thouchNumber(num:Int){
        thouchNum = num;
        
    }
    //MARK:获取到数据的方法
    func fristGetData(dict:NSDictionary){  // 第1种
        print("qqqqqqqqqqqqq")
        print(dict);
    }
    func secondGetData(json:NSDictionary){  // 第2种
        let dictttt:NSArray =  ((json["RET"] as! [String: Any])["Sys_GX_ZJ"] as! NSArray)
        kj_dict = dictttt[thouchNum] as! NSDictionary
//        total = (json["RET"] as! [String: Any])["Record_Count"] as! Int
        self.loadDataToView()
    }
    
    // MARK:加载数据
    func loadDataToView(){
        
        // 显示文字
        self.loadText(title:kj_dict["GJ_NAME"] as! String, text:kj_dict["GJ_CONTENT_CN"] as! String)
    }
    
    func loadText(title:String,text:String){
        let attributedTextString = NSMutableAttributedString(string:text, attributes: [NSForegroundColorAttributeName: UIColor.black, NSKernAttributeName: (textFont/6), NSFontAttributeName: UIFont.systemFont(ofSize: textFont)])
        let attributedTitleString = NSMutableAttributedString(string:title + "\n", attributes:[NSKernAttributeName: (titleFont/6), NSFontAttributeName: UIFont.systemFont(ofSize: titleFont)])
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        attributedTitleString.append(attributedTextString)
        textView.attributedText = attributedTitleString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        self.initView()
    }
    
    func applicationWillResignActive() {
        UIScreen.main.brightness = brightness
    }

    func applicationDidBecomeActive() {
        brightness = UIScreen.main.brightness
    }
    
    func initView() {
        
        self.initDataView()
        self.initNavBar()
        self.initPageButton()
        self.initTabBar()
        self.initListView()
    }
    
    func initPageButton() {
        lastPage = UIButton.init(type: .system)
        lastPage.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH / 9,height:SCREEN_HEIGHT/10)
        lastPage.center = CGPoint(x:lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
        lastPage.setTitle("  上  \n  一  \n  章  ", for: .normal)
        lastPage.setTitleColor(.black, for: .normal)
        lastPage.backgroundColor = UIColor.white
        lastPage.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        self.view!.addSubview(lastPage)
        nextPage = UIButton.init(type:.system)
        nextPage.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH / 9,height:SCREEN_HEIGHT/10)
        nextPage.center = CGPoint(x:SCREEN_WIDTH-nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
        nextPage.setTitle("  下  \n  一  \n  章  ", for: .normal)
        nextPage.setTitleColor(.black, for: .normal)
        nextPage.backgroundColor = UIColor.white
        nextPage.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        self.view!.addSubview(nextPage)
    }
    
    func initListView() {
        listView = ListViewController.init()
        listView.view!.frame = CGRect(x:-SCREEN_WIDTH,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        listView.view!.backgroundColor = UIColor.red
        self.addChildViewController(listView)
        self.view.addSubview(listView.view)
    }
    
    func initDataView() {
        
        dataView = UIScrollView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
        dataView.backgroundColor = LIGHT
        self.view!.addSubview(dataView)
        
        let backImage = UIImage(named:"yellowBackground")!
        backImageView.image = backImage
        backImageView.frame = CGRect(x:0, y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        dataView.addSubview(backImageView)

        textView.frame = CGRect(x:MARGIN+MARGIN/7, y:MARGIN, width:SCREEN_WIDTH-2*MARGIN, height:SCREEN_HEIGHT-2.5*MARGIN)
        textView.backgroundColor = UIColor.clear
        dataView.addSubview(textView)
        
        let tapRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.tapText))
        let longPressRecongnizer = UILongPressGestureRecognizer(target: self, action:#selector(self.longPress))
        textView.addGestureRecognizer(tapRecongnizer)
        textView.addGestureRecognizer(longPressRecongnizer)
    }
    
    func initTabBar() {
        selfTabBar = UITabBar.init(frame: CGRect(x:0, y:SCREEN_HEIGHT-TABBAR_HEIGHT, width:SCREEN_WIDTH, height:TABBAR_HEIGHT))
//        selfTabBar.backgroundColor = UIColor.red
        selfTabBar.tintColor = UIColor.blue
        let setImage = UIImage(named: "shezhi")!.withRenderingMode(.alwaysOriginal)
        let darkImage = UIImage(named: "yejian")!.withRenderingMode(.alwaysOriginal)
//        let lightImage = UIImage(named: "rijian")!.withRenderingMode(.alwaysOriginal)
        let likeImage = UIImage(named: "shoucang")!.withRenderingMode(.alwaysOriginal)
        let listImage = UIImage(named: "mulu")!.withRenderingMode(.alwaysOriginal)
        let brightImage = UIImage(named:"jindu")!.withRenderingMode(.alwaysOriginal)
        
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:0.8))
        view.backgroundColor = UIColor.lightGray
        selfTabBar.addSubview(view)
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 10.0), NSForegroundColorAttributeName: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red:0,green:0,blue:0,alpha:1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red:0.6,green:0.6,blue:0.6,alpha:1)], for: .selected)
        // MARK:tabBarItem's tag ,from 800 to 804
        let firb = UITabBarItem.init(title:"目录", image: listImage, selectedImage: listImage)
        firb.tag = 800;
        let secb = UITabBarItem.init(title:"喜欢", image: likeImage, selectedImage: likeImage)
        secb.tag = 801;
        let thib = UITabBarItem.init(title:"亮度", image: brightImage, selectedImage: brightImage)
        thib.tag = 802;
        let img = UIImage(named: "rijian")
        let forb = UITabBarItem.init(title:"夜间", image: darkImage, selectedImage: img)
        forb.tag = 803;
        let fifb = UITabBarItem.init(title:"设置", image: setImage, selectedImage: setImage)
        fifb.tag = 804;
        selfTabBar.setItems([firb,secb,thib,forb,fifb], animated: false)
        selfTabBar.delegate = self;
        self.view!.addSubview(selfTabBar)
        
        touchView = UIView.init(frame: MY_CGRECT(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(self.touchLightBackground))
        touchView.addGestureRecognizer(ges)
        touchView.isHidden = true
        self.view!.addSubview(touchView)
        
        lightView = UIView.init(frame: MY_CGRECT(x: 100, y: 500, width: 200, height: 50))
        lightView.backgroundColor = UIColor.white
        lightView.alpha = 0
        
        //TODO: Slider.size修改
        lightSlider = UISlider.init(frame: MY_CGRECT(x: 0, y: 0, width: 200, height: 20))
        lightSlider.backgroundColor = UIColor.blue
        lightSlider.setThumbImage(self.originImage(image: setImage, size: CGSize(width:20,height:20)), for: .normal)
        lightSlider.addTarget(self, action: #selector(self.controlBright), for: .valueChanged)
        lightView.addSubview(lightSlider)
        self.view!.addSubview(lightView)
        
        setView.frame = MY_CGRECT(x: 200, y: 400, width: 175, height: 175)
        setView.alpha = 0
        setView.backgroundColor = UIColor.white
        self.view!.addSubview(setView)
    }
    
    func originImage(image:UIImage,size:CGSize)->(UIImage) {
        UIGraphicsBeginImageContext(size)
        image.draw(in: MY_CGRECT(x: 0, y: 0, width: size.width, height: size
    .height))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img;
    }
    
    func initNavBar() {
        statusView = UIView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:STATUS_HEIGHT))
        statusView.backgroundColor = UIColor.red
        //        self.view!.addSubview(statusView)
        navView = UIView.init(frame: CGRect(x:0, y:STATUS_HEIGHT, width:SCREEN_WIDTH, height:NAV_HEIGHT))
        navView.backgroundColor = UIColor.red
        //        self.view!.addSubview(navView)
        
        let backImage = UIImage(named: "fanhui")!.withRenderingMode(.alwaysOriginal)
        let shareImage = UIImage(named: "fenxiang")!.withRenderingMode(.alwaysOriginal)
        navBar = UINavigationBar.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:NAV_HEIGHT+STATUS_HEIGHT))
        let lb = UIBarButtonItem.init(image:backImage, style:.plain, target:self, action:#selector(self.clickLeftButton))
        let rb = UIBarButtonItem.init(image:shareImage, style:.plain, target:self, action:#selector(self.clickRightButton))
        let bbi = UINavigationItem(title:kj_title)
        bbi.leftBarButtonItem = lb
        bbi.rightBarButtonItem = rb
        navBar.pushItem(bbi, animated:true)
        
        //        navView.addSubview(navBar)
        self.view!.addSubview(navBar)
    }
    
    // MARK: Actions
    func longPress() {
        
    }
    
    func controlBright() {
        UIScreen.main.brightness = CGFloat(lightSlider.value)
    }
    
    func touchLightBackground() {
        lightView.alpha = 0
        setView.alpha = 0
        touchView.isHidden = true
    }
    
    func tapText() {
        if isTap {
            isTap = false
//            navBar.isHidden = false
//            selfTabBar.isHidden = false
            DispatchQueue.main.async(execute: {() -> Void in
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    self.navBar.frame = CGRect(x:0, y:0, width:SCREEN_WIDTH, height:NAV_HEIGHT+STATUS_HEIGHT)
                    self.selfTabBar.frame = CGRect(x:0, y:SCREEN_HEIGHT-TABBAR_HEIGHT, width:SCREEN_WIDTH, height:TABBAR_HEIGHT)
                    self.nextPage.center = CGPoint(x:SCREEN_WIDTH-self.nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    self.lastPage.center = CGPoint(x:self.lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    }, completion: { (true) in
                        
                })
            })
        }
        else {
            self.isTap = true
//            self.navBar.isHidden = true
//            self.selfTabBar.isHidden = true
            DispatchQueue.main.async(execute: {() -> Void in
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    self.navBar.frame = CGRect(x:0, y:-NAV_HEIGHT-STATUS_HEIGHT, width:SCREEN_WIDTH, height:NAV_HEIGHT+STATUS_HEIGHT)
                    self.selfTabBar.frame = CGRect(x:0, y:SCREEN_HEIGHT+TABBAR_HEIGHT, width:SCREEN_WIDTH, height:TABBAR_HEIGHT)
                    self.nextPage.center = CGPoint(x:SCREEN_WIDTH+self.nextPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    self.lastPage.center = CGPoint(x:-self.lastPage.bounds.size.width/2,y:SCREEN_HEIGHT/2)
                    }, completion: { (true) in
                        
                })
            })

//            DispatchQueue.main.async(execute: {() -> Void in
//                self.dataView.frame = CGRect(x:MARGIN, y:-NAV_HEIGHT-STATUS_HEIGHT, width:SCREEN_WIDTH-2*MARGIN, height:SCREEN_HEIGHT)
//            })
        }
    }
    
    func clickLeftButton() {
        print("woshis")
        self.dismiss(animated:true, completion:nil)
    }
    
    func clickRightButton() {
        print("nisagho")
        let shareBut = ShareView()
        shareBut.setShareContent = .ShareMusic
        shareBut.title = "title"
        shareBut.describe = "这是一段简单的描述"
        shareBut.thumbImage = networkPictureUrl_swift
        shareBut.musicUrl = "http://mp3.haoduoge.com/s/2016-05-03/1462273909.mp3"
        self.view.addSubview(shareBut)
    }
    
    func clickFirb() {
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect Item: UITabBarItem) {
        if tabBar == selfTabBar {
            if Item.tag == 800 {

                DispatchQueue.main.async(execute: {() -> Void in
                    
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                        self.listView.view!.frame = CGRect(x:-SCREEN_WIDTH/3,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
                        self.view!.frame = CGRect(x:SCREEN_WIDTH/3,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
                        }, completion: { (true) in
                            
                    })
                })
            }
            else if Item.tag == 801 {
                print("like")
            }
            else if Item.tag == 802 {
                self.popSlider()
            }
            else if Item.tag == 803 {
                self.lightOrDark(Item:Item)
            }
            else if Item.tag == 804 {
                self.popSetView()
            }
        }
    }
    
    func popSlider() {
        lightView.alpha = 1
        self.touchView.isHidden = false
    }

    func lightOrDark(Item:UITabBarItem) {
        if !isDark {
            isDark = true
            var image = UIImage(named: "rijian")!.withRenderingMode(.alwaysOriginal)
            Item.image = image
            image = UIImage(named: "rijian")!.withRenderingMode(.alwaysOriginal)
            Item.selectedImage = image
            self.setStyle(color: DARK)
        } else {
            isDark = false
            var image = UIImage(named: "yejian")!.withRenderingMode(.alwaysOriginal)
            Item.image = image
            image = UIImage(named: "yejian")!.withRenderingMode(.alwaysOriginal)
            Item.selectedImage = image
            self.setStyle(color: LIGHT)
        }
    }
    
    func setStyle(color:UIColor) {
        if color == UIColor.white {
            backImageView.alpha = 1
            textView.textColor = DARK
            textView.backgroundColor = UIColor.clear
            lastPage.titleLabel?.textColor = DARK
            lastPage.backgroundColor = color
            nextPage.titleLabel?.textColor = DARK
            nextPage.backgroundColor = color
        } else {
            backImageView.alpha = 0
            textView.textColor = LIGHT
            textView.backgroundColor = color
            lastPage.titleLabel?.textColor = LIGHT
            lastPage.backgroundColor = GRAY
            nextPage.titleLabel?.textColor = LIGHT
            nextPage.backgroundColor = GRAY
        }
        dataView.backgroundColor = color
        navBar.backgroundColor = color
        selfTabBar.backgroundColor = color
    }
    
    func popSetView() {
        setView.alpha = 1
        self.touchView.isHidden = false
    }
}

