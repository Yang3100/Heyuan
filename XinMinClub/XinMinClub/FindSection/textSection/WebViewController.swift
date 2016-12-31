//
//  WebViewController.swift
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

import UIKit

class WebViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setNavigationBar()
        self.view.addSubview(self.webView)
    }

    func setNavigationBar() {
        let btn2=UIButton()
        btn2.frame = CGRect(x:10, y:27, width:20, height:25)
        btn2.setImage(UIImage(named:"goback"), for:.normal)
        btn2.addTarget(self, action:#selector(buttonAction2(sender:)), for: UIControlEvents.touchUpInside)
        //        let item2 = UIBarButtonItem(customView:btn1)
        //        self.navigationItem.rightBarButtonItem = item2
        self.view.addSubview(btn2)
        
        let lab = UILabel()
        lab.frame = CGRect(x:0, y:0, width:screenWidth-70, height:30)
        lab.center = CGPoint(x:screenWidth/2,y:42)
        lab.text = "掌门说玉"
        lab.textAlignment = .center
        self.view.addSubview(lab)
    }
    
    func buttonAction2(sender:UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    private lazy var webView : UIWebView = {
        let wv = UIWebView()
        wv.frame = CGRect(x:0, y:64, width:screenWidth, height:screenHeight-64)
        wv.backgroundColor = .gray
        return wv
    }()

}
