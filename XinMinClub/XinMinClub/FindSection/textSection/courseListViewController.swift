//
//  courseListViewController.swift
//  course
//
//  Created by 杨科军 on 2016/11/24.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import Foundation

let navigationBarHeight:CGFloat = 64.0


class courseListViewController : UINavigationController,UITableViewDataSource,UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.headerImage)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.backTableView)
        
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        courseListViewController.teacherIntroSwitch! = false
    }
    
    var adID:NSString = ""   // 滚动广告
    var findDict:NSDictionary = [:] {
        didSet {
            var sss:String = ""
            if adID.length != 0 {
                sss = adID as String
//                (self.headerView.subviews[1] as! UILabel).text = findDict.value(forKey:"ADV_TITLE") as? String
            }else{
                sss = findDict.value(forKey:"KC_ID") as! String
            }
            
            let imageString:String = ip + (findDict.value(forKey:"KC_IMG") as? String)!
            let url:URL = URL(string:imageString)!
//            print(url)
            self.headerImage.sd_setImage(with:url)
//                , placeholderImage:headerIm)
            (self.headerView.subviews[1] as! UILabel).text = findDict.value(forKey:"KC_NAME") as? String
            
            let dicc:NSDictionary = ["KC_ID":sss,"Page_Index":"1","Page_Count":"10000"]
            self.getFindJsonn(dic:dicc)
        }
    }
    
    private var findDataArray:NSArray = []
    func getFindJsonn(dic:NSDictionary){
        LoadAnimation.defaultDataModel().start()
        let str:String = networkSection.getParamString(param:["FunName":"Get_ZKC_DataList","Params":dic])
        networkSection.getRequestDataBlock(ipurl, str, block:{(json) -> Void in
//            print("************************************")
//                        print(json)
            DispatchQueue.main.async {
                LoadAnimation.defaultDataModel().end()
                self.findDataArray = (json["RET"] as! [String: Any])["Sys_KCXJ"] as! NSArray
            self.backTableView.reloadData()
            }
        })
    }
    
    func setNavigationBar() {
        // 自定义navigationBar
        let btn1=UIButton()
        btn1.frame = CGRect(x:screenWidth-40, y:27, width:30, height:30)
        btn1.setImage(UIImage(named:"gerenjianjie"), for:.normal)
        btn1.addTarget(self, action:#selector(buttonAction1(sender:)), for: UIControlEvents.touchUpInside)
//        let item2 = UIBarButtonItem(customView:btn1)
//        self.navigationItem.rightBarButtonItem = item2
        self.view.addSubview(btn1)
        
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
        lab.text = "课程列表"
        lab.textAlignment = .center
        self.view.addSubview(lab)
    }
    
    static var teacherIntroSwitch:Bool? = false
    private var tIntro : teacherIntro!
    func buttonAction1(sender:UIButton) {
        if courseListViewController.teacherIntroSwitch!==false {
            tIntro = teacherIntro(frame:CGRect(x:0, y:64, width:screenWidth, height:screenHeight-64),teacherData:findDict)
            self.view.addSubview(tIntro)
            courseListViewController.teacherIntroSwitch! = true
        }
        else {
            tIntro.removeFromSuperview()
            courseListViewController.teacherIntroSwitch! = false
        }
    }
    
    func buttonAction2(sender:UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    //MARK:UI界面
    private lazy var headerImage : UIImageView = {
        let hi = UIImageView()
        hi.frame = CGRect(x:15, y:8+navigationBarHeight, width:screenWidth-30, height:44)
        hi.image = cachePicture_350x44
        
        return hi
    }()
    private lazy var headerView : UIView = {
        let vi = UIView(frame:CGRect(x:15,y:60+navigationBarHeight,width:screenWidth-30,height:35))
        vi.layer.masksToBounds = true
        vi.layer.borderWidth = 0.5
        vi.layer.cornerRadius = 1
        vi.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        vi.backgroundColor = UIColor(red:1, green:252/255, blue:235/255, alpha:1)
        
        let laa = UILabel(frame:CGRect(x:0,y:0,width:30,height:35))
        laa.text = " ➢ "
        laa.backgroundColor = UIColor.clear
        laa.font = UIFont(name:"Arial", size:20)
        vi.addSubview(laa)
        let la = UILabel(frame:CGRect(x:28,y:0,width:screenWidth-58,height:35))
        la.text = "课程名"
        la.backgroundColor = UIColor.clear
        la.font = UIFont(name:"Arial", size:14)
        vi.addSubview(la)
        return vi
    }()
    private lazy var backTableView : UITableView = {
        var btv = UITableView(frame:CGRect(x:15, y:95+navigationBarHeight, width:screenWidth-30, height:screenHeight-167), style:UITableViewStyle.plain)
        btv.backgroundColor = UIColor(red:235/255, green:235/255, blue:235/255, alpha:1)
        btv.delegate = self
        btv.dataSource = self
        //        btv.bounces = false  // 关闭弹性
        btv.showsHorizontalScrollIndicator = false
        btv.showsVerticalScrollIndicator = false
        // Nib 注册
        btv.register(UINib(nibName:"courseListCell", bundle:nil), forCellReuseIdentifier:"courseListCell")
        return btv
    }()
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let cell = tableView.dequeueReusableCell(withIdentifier:"courseListCell") as! courseListCell
        cell.selectionStyle = .none
        _ = self.findDataArray[indexPath.row] as! NSDictionary
        (cell ).name1 = (self.findDataArray[indexPath.row] as! NSDictionary).value(forKey:"KCXJ_NAME") as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wvc =  WebViewController()
        wvc.teacher = (findDict.value(forKey:"KC_CONTENT") as? String)!
        wvc.kcID = findDict.value(forKey:"KC_ID") as! String
        wvc.setDic(dic: self.findDataArray[indexPath.row] as! NSDictionary)
        self.present(wvc, animated: true, completion:nil)
    }
    
}

