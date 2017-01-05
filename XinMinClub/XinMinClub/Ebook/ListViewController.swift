//
//  ListViewController.swift
//  HeyuanSwfit_11_9
//
//  Created by 赵劲松 on 16/11/14.
//  Copyright © 2016年 赵劲松. All rights reserved.
//

import UIKit

let BTN_WIDTH:CGFloat = 50
let BTN_HEIGHT:CGFloat = 30

class ListViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate {

    var directoryBtn = UIButton()
    var bookMarkBtn = UIButton()
    var scroll = UIScrollView()
    var backBtn = UIButton()
    var kj_cell:UITableViewCell?
    
    var kj_isLightStyle:Bool = true {  // 是否为日间模式
        willSet {
            
        }
        didSet {
            if kj_isLightStyle {  // 日间模式
                self.view.backgroundColor = UIColor(white:0.0, alpha:0.7)
                directoryBtn.setTitleColor(DARK, for: .normal)
                self.kj_table.backgroundView = UIImageView(image:UIImage(named:"日间模式"))
            }else{   // 夜间模式
                self.view.backgroundColor = UIColor(white:0.0, alpha:1.0)
                directoryBtn.setTitleColor(.white, for: .normal)
                self.kj_table.backgroundView = UIImageView(image:UIImage(named:"夜间背景"))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white:0.0, alpha:0.7)
        
        self.initScrollView()
        self.initButton()
    }
    
    var dataArray: NSArray = [] {
        willSet {
            
        }
        didSet {
            self.kj_table.reloadData()
        }    
    }
    
    func initButton() {
        backBtn = UIButton.init(type: .system)
        backBtn.frame = CGRect(x:SCREEN_WIDTH*9/10,y:SCREEN_HEIGHT-TABBAR_HEIGHT/2 - SCREEN_WIDTH/20,width:SCREEN_WIDTH/10,height:SCREEN_WIDTH/10)
        let backImage = UIImage(named:"fanhui1")!.withRenderingMode(.alwaysOriginal)
        backBtn.setImage(backImage, for: .normal)
        backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view!.addSubview(backBtn)
        
        directoryBtn = UIButton.init(type: .system)
        directoryBtn.frame = MY_CGRECT(x:(SCREEN_WIDTH-BTN_WIDTH)/2, y: NAV_HEIGHT+STATUS_HEIGHT-BTN_HEIGHT-MARGIN/2, width: BTN_WIDTH, height: BTN_HEIGHT)
        directoryBtn.setTitle("目录", for: .normal)
        directoryBtn.setTitleColor(DARK, for: .normal)
        directoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        directoryBtn.addTarget(self, action: #selector(self.dir), for: .touchUpInside)
        self.view!.addSubview(directoryBtn)
    }
    
    private func initScrollView() {
        scroll = UIScrollView.init()
        scroll.frame = CGRect(x:0,y:STATUS_HEIGHT+NAV_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT)
        scroll.backgroundColor = .clear
        scroll.contentSize = CGSize(width:SCREEN_WIDTH*2, height:scroll.frame.size.height);
        //        scroll.isPagingEnabled = false
        scroll.isScrollEnabled = false
        scroll.showsHorizontalScrollIndicator = false
        self.view!.addSubview(scroll)
        
        scroll.addSubview(self.kj_table)
        
//        let view = UIView()
//        view.frame = CGRect(x:SCREEN_WIDTH,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT)
//        view.backgroundColor = UIColor.yellow
//        scroll.addSubview(view)
    }
    
    
    //MARK: - UI界面
    public lazy var kj_table : UITableView = {
        var kj_table = UITableView.init(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT), style: .plain)
        kj_table.backgroundView = UIImageView(image:UIImage(named:"日间模式"))
        kj_table.delegate = self
        kj_table.dataSource = self
        return kj_table
    }()

    

    func back() {
        self.dismiss(animated:true, completion:{ (true) in
            
        })
    }
    
    // MARK:Actions
    func dir() {
        scroll.scrollRectToVisible(CGRect(x:0,y:STATUS_HEIGHT+NAV_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT), animated: true)
    }
    
    func mark() {
        scroll.scrollRectToVisible(CGRect(x:SCREEN_WIDTH,y:STATUS_HEIGHT+NAV_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT), animated: true)
    }
    
    // MARK:tableViewDelegate & dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        kj_cell = UITableViewCell()
        kj_cell?.textLabel?.text = "  " + ((dataArray[indexPath.row] as! NSDictionary)["GJ_NAME"] as? String)!
        kj_cell?.backgroundColor = UIColor.clear
        if kj_isLightStyle {
            kj_cell?.textLabel?.textColor = UIColor(red:68/255.0, green:68/255.0, blue:68/255.0, alpha:1.0)
        }else{
            kj_cell?.textLabel?.textColor = UIColor(red:81/255.0, green:133/255.0, blue:203/255.0, alpha:1.0)
        }
        return kj_cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ebook = EBookViewController.shareSingleOne
        self.dismiss(animated:true, completion:{ (true) in
            ebook.loadDataToView(array:self.dataArray, Num:indexPath.row)
        })
    }
}
