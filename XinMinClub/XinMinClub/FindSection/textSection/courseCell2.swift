//
//  courseCell2.swift
//  course
//
//  Created by 杨科军 on 2016/11/22.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit
import Foundation


class courseCell2 : UITableViewCell,MJscrollDeledage {

    var imageArray:Array<UIImage>?
    
    func getDataAfterLoadData() {
        MJscroll.initWithSourceArray(self.imageArray!, addTarget:self, delegate: self, withSize:CGRect(x:0,y:0,width:screenWidth,height:screenHeight/3-64))
        self.addSubview(self.courseLabel)
    }
    
    func mJscrollImage(_ bannerPlayer: UIView!, didSelectedIndex index: Int) {
        print("dianji \(index)")
        let clvc = courseListViewController()
        clvc.view.backgroundColor = UIColor.white
        self.AppRootViewController()?.present(clvc, animated: true, completion: {
            //            clvc.navigationController?.isToolbarHidden = true;
        })        
    }
    
    func AppRootViewController() -> UIViewController? {
        var topVC  = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }

    
//    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
//        super.init(style:style, reuseIdentifier:reuseIdentifier)
//        
////        self.addSubview(self.couScrollView)
////        MJBannnerPlayer.initWithSourceArray(self.imageArray, addTarget: self, delegate: self, withSize: CGRect(x:0,y:0,width:screenWidth,height:180))
////        self.addSubview(self.courseLabel)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    private var courseLabel : UILabel = {
        let cl = UILabel()
        cl.frame = CGRect(x:screenWidth-65,y:screenHeight/3-84,width:65,height:20)
        cl.backgroundColor = UIColor(red:102/255, green:101/255, blue:102/255, alpha:0.6)
        cl.textColor = UIColor.white
        cl.text = "热门课程"
        cl.font = UIFont.boldSystemFont(ofSize:13)
        cl.textAlignment = .center
        return cl
    }()
}
