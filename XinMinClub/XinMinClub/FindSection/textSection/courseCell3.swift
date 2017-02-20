//
//  courseCell3.swift
//  course
//
//  Created by 杨科军 on 2016/11/22.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class courseCell3: UITableViewCell {
    
//    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
//        super.init(style:style, reuseIdentifier:reuseIdentifier)
//        
////        self.addSubview(self.courseC)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    public var dataArray3:NSArray = [] {
        didSet {
//            self.courseImageView.addSubview(self.textNameLabel)
//            self.textNameLabel.text = nameString
            if dataArray3.count==0 {
                let view = UILabel()
                view.frame = CGRect(x:(screenWidth-screenWidth/2)/2,y:30,width:screenWidth/2,height:(screenHeight-108)/2)
                view.text = "网络连接失败请检查你的网络"
                view.textAlignment = .center
                view.numberOfLines = 0
//                view.center = self.center
//                view.backgroundColor = .red
                self.addSubview(view)
            }else{
                let lay = UICollectionViewFlowLayout()
                let ccoll = courseCollection(frame:CGRect(x:0,y:0,width:screenWidth,height:screenHeight-108), layout:lay, array:dataArray3)
                self.addSubview(ccoll)
            }
        }
    }
    
//    private var courseC : courseCollection = {
////        let dic = NSDictionary(objects: ["和氏var","001",UIImage(named:"a") as Any,"10","998.00","12","1"], forKeys: ["GoodsName" as NSCopying,"GoodsID" as NSCopying,"GoodsImage" as NSCopying,"GoodsStock" as NSCopying,"GoodsPrice" as NSCopying,"GoodsExpress" as NSCopying,"GoodsSelectCount" as NSCopying])
//        
//        let lay = UICollectionViewFlowLayout()
//        let ccoll = courseCollection(frame:CGRect(x:0,y:0,width:screenWidth,height:screenHeight-108), layout:lay)
//        
//        return ccoll
//    }()
}
