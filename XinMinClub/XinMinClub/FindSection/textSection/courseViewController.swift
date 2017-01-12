//
//  ViewController.swift
//  course
//
//  Created by 杨科军 on 2016/11/22.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit
import Foundation

let ipz:String = "http://218.240.52.135"
//"http://192.168.137.1"
//

let ipzurl:String = "http://218.240.52.135/App/App.ashx"
//"http://192.168.137.1/App/App.ashx"
//

let headerIm:UIImage = UIImage(named:"header")!
let teacherIm:UIImage = UIImage(named:"taoci.jpg")!


class courseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getFindJsonn()
        
        self.view.addSubview(self.backTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    private var findDataArray:NSArray = []
    func getFindJsonn(){
        LoadAnimation.defaultDataModel().start()
        let dic:NSDictionary = ["KC_ID":"","Page_Index":"1","Page_Count":"10000"]
        let str:String = networkSection.getParamString(param:["FunName":"Get_KC_DataList","Params":dic])
        networkSection.getRequestDataBlock(ipzurl, str, block:{(json) -> Void in
//            print("***************66666*********************")
//            print(json)
            DispatchQueue.main.async {
                LoadAnimation.defaultDataModel().end()
                self.findDataArray = (json["RET"] as! [String: Any])["Sys_KC"] as! NSArray
                self.backTableView.reloadData()
            }
        })
    }
    
    //MARK: - UI界面
    private lazy var backTableView : UITableView = {
        var btv = UITableView(frame:CGRect(x:0, y:0, width:screenWidth, height:screenHeight-108), style:.plain)
        btv.backgroundColor = UIColor.white
        btv.delegate = self
        btv.dataSource = self
        btv.bounces = false
        btv.showsHorizontalScrollIndicator = false
        btv.showsVerticalScrollIndicator = false
        // Nib 注册
        btv.register(courseCell2.self, forCellReuseIdentifier:"courseCell2")
        btv.register(courseCell3.self, forCellReuseIdentifier:"courseCell3")
        return btv
    }()
    
    //MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return screenHeight/3-64
        }
        else {
            return screenHeight-108
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell?
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier:"courseCell2") as! courseCell2
            (cell as! courseCell2).getDataAfterLoadData()
            return cell!
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier:"courseCell3") as! courseCell3
            (cell as! courseCell3).dataArray3 = self.findDataArray
            return cell!
        }
        // 隐藏线条
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==1 {
            return 27
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let vi = UIView()
            let laa = UILabel(frame:CGRect(x:0,y:0,width:30,height:27))
            laa.text = " ➢ "
            laa.backgroundColor = UIColor.white
            laa.font = UIFont(name:"Arial", size:20)
            vi.addSubview(laa)
            let la = UILabel(frame:CGRect(x:28,y:0,width:screenWidth-28,height:27))
            la.text = "全部课程"
            la.backgroundColor = UIColor.white
            la.font = UIFont(name:"Arial", size:13)
            vi.addSubview(la)
            let xian = UIView()
            xian.frame = CGRect(x:5,y:26,width:screenWidth-10,height:1)
            xian.backgroundColor = UIColor(red:181/255, green:181/255, blue:181/255, alpha:0.8)
            vi.addSubview(xian)
            return vi
        }
        else {
            return nil
        }
    }
    
    //MARK:滚动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if Float(scrollView.bounds.origin.y)>Float(screenHeight/3-64) {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "scrollIsLock"), object:nil, userInfo:["scrollY":Float(scrollView.bounds.origin.y)])
//        }
//        else {
//            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "scrollIsLock"), object:nil, userInfo:["scrollY":Float(scrollView.bounds.origin.y)])
//        }
    }
}

