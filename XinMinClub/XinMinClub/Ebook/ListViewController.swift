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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initScrollView()
        self.initButton()
    }
    
    func initButton() {
        backBtn = UIButton.init(type: .system)
        backBtn.frame = CGRect(x:SCREEN_WIDTH*9/10,y:SCREEN_HEIGHT-TABBAR_HEIGHT/2 - SCREEN_WIDTH/20,width:SCREEN_WIDTH/10,height:SCREEN_WIDTH/10)
        let backImage = UIImage(named: "fanhui1")!.withRenderingMode(.alwaysOriginal)
        backBtn.setImage(backImage, for: .normal)
        backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view!.addSubview(backBtn)
        
        directoryBtn = UIButton.init(type: .system)
        directoryBtn.frame = MY_CGRECT(x:(SCREEN_WIDTH-BTN_WIDTH)/2, y: NAV_HEIGHT+STATUS_HEIGHT-BTN_HEIGHT-MARGIN/2, width: BTN_WIDTH, height: BTN_HEIGHT)
//        let backImage = UIImage(named: "fanhui1")!.withRenderingMode(.alwaysOriginal)
//        directoryBtn.setImage(backImage, for: .normal)
        directoryBtn.setTitle("目录", for: .normal)
        directoryBtn.setTitleColor(DARK, for: .normal)
        directoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        directoryBtn.addTarget(self, action: #selector(self.dir), for: .touchUpInside)
        self.view!.addSubview(directoryBtn)
        
//        bookMarkBtn = UIButton.init(type: .system)
//        bookMarkBtn.frame = MY_CGRECT(x: SCREEN_WIDTH/2, y: NAV_HEIGHT+STATUS_HEIGHT-BTN_HEIGHT-MARGIN/2, width: BTN_WIDTH, height: BTN_HEIGHT)
//        let backImage = UIImage(named: "fanhui1")!.withRenderingMode(.alwaysOriginal)
//        bookMarkBtn.setImage(backImage, for: .normal)
//        bookMarkBtn.setTitle("书签", for: .normal)
//        bookMarkBtn.setTitleColor(DARK, for: .normal)
//        bookMarkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        bookMarkBtn.addTarget(self, action: #selector(self.mark), for: .touchUpInside)
//        self.view!.addSubview(bookMarkBtn)
//        
    }
    
    func initScrollView() {
        
        scroll = UIScrollView.init()
        scroll.frame = CGRect(x:0,y:STATUS_HEIGHT+NAV_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT)
        scroll.backgroundColor = UIColor.white
        scroll.contentSize = CGSize(width:SCREEN_WIDTH*2, height:scroll.frame.size.height);
        //        scroll.isPagingEnabled = false
        scroll.isScrollEnabled = false
        scroll.showsHorizontalScrollIndicator = false
        self.view!.addSubview(scroll)
        
        var table = UITableView()
        table = UITableView.init(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT), style: .plain)
        table.backgroundColor = UIColor.blue
        table.delegate = self
        table.dataSource = self
        //        self.view!.addSubview(table)
        scroll.addSubview(table)
        let view = UIView()
        view.frame = CGRect(x:SCREEN_WIDTH,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT-TABBAR_HEIGHT-NAV_HEIGHT-STATUS_HEIGHT)
        view.backgroundColor = UIColor.yellow
        scroll.addSubview(view)
    }

    func back() {
        DispatchQueue.main.async(execute: {() -> Void in
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.parent?.view!.frame = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
                self.view!.frame = CGRect(x:-SCREEN_WIDTH,y:0,width:SCREEN_WIDTH,height:SCREEN_HEIGHT)
                }, completion: { (true) in
                    
            })
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "今天好玩"
        cell.backgroundColor = UIColor.gray
        return cell
    }
}
