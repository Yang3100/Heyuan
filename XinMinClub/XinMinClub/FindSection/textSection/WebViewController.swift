//
//  WebViewController.swift
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

import UIKit

class WebViewController: UINavigationController {

    private var dataDic:NSDictionary = NSDictionary()
    private var workWebView:UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
//        self.view.addSubview(self.webView)
        self.setWebView()
    }

    func setDic(dic:NSDictionary) {
        dataDic = dic
        let s = dic.value(forKey: "KCXJ_ID") as! String
//        http://www.kingwant.com/BizFunction/KC/ZiKeChen/Html/Sys_ZKC_Info.aspx?ID=2b7611cd-a7cc-4efa-a4e1-d38004e1e0b1
        let urlHead = "http://218.240.52.135/m/KC/Html/kc_Info.aspx?ID="
        let url = NSURL.init(string: urlHead+s)
        let request = NSURLRequest.init(url: url as! URL)
        workWebView.loadRequest(request as URLRequest)
        
        self.setNavigationBar()
    }
    
    func setWebView() {
        workWebView.frame = MY_CGRECT(x: 0, y: 64, w: SCREEN_WIDTH, h: SCREEN_HEIGHT-64)
        self.view!.addSubview(workWebView)
    }
    
    func setNavigationBar() {
        let btn2=UIButton()
        btn2.frame = CGRect(x:10, y:27, width:30, height:30)
        btn2.setImage(UIImage(named:"goback"), for:.normal)
        btn2.addTarget(self, action:#selector(buttonAction2(sender:)), for: UIControlEvents.touchUpInside)
        //        let item2 = UIBarButtonItem(customView:btn1)
        //        self.navigationItem.rightBarButtonItem = item2
        self.view.addSubview(btn2)
        
        let lab = UILabel()
        lab.frame = CGRect(x:0, y:0, width:screenWidth-70, height:30)
        lab.center = CGPoint(x:screenWidth/2,y:42)
        lab.text = dataDic.value(forKey:"KCXJ_NAME") as? String
        lab.textAlignment = .center
        self.view.addSubview(lab)
    }
    
    func buttonAction2(sender:UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    private lazy var webView : UIWebView = {
        let wv = UIWebView()
        wv.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight-64)
        wv.backgroundColor = .gray
        return wv
    }()

}
