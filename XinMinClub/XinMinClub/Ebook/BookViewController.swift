//
//  ViewController.swift
//  HeyuanSwfit_11_9
//
//  Created by 赵劲松 on 16/11/9.
//  Copyright © 2016年 赵劲松. All rights reserved.
//

import UIKit

let STATUS_HEIGHT:CGFloat = 20
let NAV_HEIGHT:CGFloat = 44
let TABBAR_HEIGHT:CGFloat = 49
let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let CONTENT_VIEW_HEIGHT = SCREEN_HEIGHT-STATUS_HEIGHT-NAV_HEIGHT-TABBAR_HEIGHT
let MARGIN:CGFloat = 20
let TEXT_BACK_COLOR = (UIColor.white)
let DARK = (UIColor.black)
let LIGHT = (UIColor.white)
let GRAY = (UIColor.gray)

func MY_CGRECT(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)->(CGRect) {
    return CGRect(x:x,y:y,width:width,height:height)
}

class BookViewController: UIViewController ,UITabBarDelegate {
    
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
//    
//        init() {
//            super.init(nibName: nil, bundle: nil)
//        }
//    
//        required convenience init?(coder aDecoder: NSCoder) {
//    //        fatalError("init(coder:) has not been implemented")
//            self.init();
//        }
    
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
        nextPage = UIButton.init(type: .system)
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
        
        let backImage = UIImage(named: "cc")!
        backImageView.image = backImage
        backImageView.frame = CGRect(x:0, y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
        dataView.addSubview(backImageView)

        textView.frame = CGRect(x:MARGIN+MARGIN/7, y:MARGIN, width:SCREEN_WIDTH-2*MARGIN, height:SCREEN_HEIGHT-2.5*MARGIN)
        
        let s = "放假萨哈票搜嘎是个安徽安徽省\n\n       啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看\n      来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了\n\n       阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给\n      拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦\n      哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快\n\n       拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国\n      看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海\n      赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈\n\n       啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶\n      算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀\n\n       省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗\n      杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给\n      拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来\n\n       哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦\n\n       好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大\n\n       海赶快拉杆噶算了哈根暗杀省 啊给拉黑来噶哈哈过来了阿里缓过来哈拉哈拉黑过啦好啦哈拉哈啦还拉黑过了哈噶不敢打韩国看来是大海赶快拉杆噶算了哈根暗杀"
        let attributedTextString = NSMutableAttributedString(string: s, attributes: [NSForegroundColorAttributeName: UIColor.black, NSKernAttributeName: (textFont/6), NSFontAttributeName: UIFont.systemFont(ofSize: textFont)])
        let attributedTitleString = NSMutableAttributedString(string: "这里是标题\n", attributes:[NSKernAttributeName: (titleFont/6), NSFontAttributeName: UIFont.systemFont(ofSize: titleFont)])
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        attributedTitleString.append(attributedTextString)
        textView.attributedText = attributedTitleString
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
        let brightImage = UIImage(named: "jindu")!.withRenderingMode(.alwaysOriginal)
        
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:0.8))
        view.backgroundColor = UIColor.lightGray
        selfTabBar.addSubview(view)
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 10.0), NSForegroundColorAttributeName: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red:0,green:0,blue:0,alpha:1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red:0.6,green:0.6,blue:0.6,alpha:1)], for: .selected)
        // MARK:tabBarItem's tag ,from 800 to 804
        let firb = UITabBarItem.init(title: "第一个", image: listImage, selectedImage: listImage)
        firb.tag = 800;
        let secb = UITabBarItem.init(title: "第二个", image: likeImage, selectedImage: likeImage)
        secb.tag = 801;
        let thib = UITabBarItem.init(title: "第三个", image: brightImage, selectedImage: brightImage)
        thib.tag = 802;
        let img = UIImage(named: "rijian")
        let forb = UITabBarItem.init(title: "第四个", image: darkImage, selectedImage: img)
        forb.tag = 803;
        let fifb = UITabBarItem.init(title: "第五个", image: setImage, selectedImage: setImage)
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
        let lb = UIBarButtonItem.init(title: "左边", style: .plain, target: self, action: #selector(self.clickLeftButton))
        lb.image = backImage
        let rb = UIBarButtonItem.init(title: "右边", style: .plain, target: self, action: #selector(self.clickRightButton))
        rb.image = shareImage
        let bbi = UINavigationItem(title:"张飞吃粑粑")
        bbi.leftBarButtonItem = lb
        bbi.rightBarButtonItem = rb
        navBar.pushItem(bbi, animated: true)
        
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
    }
    
    func clickRightButton() {
        print("nisagho")
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

