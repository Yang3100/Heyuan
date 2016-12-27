//
//  courseCollectionViewCell.swift
//  course
//
//  Created by 杨科军 on 2016/11/22.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class courseCollectionViewCell: UICollectionViewCell {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        self.courseImageView.addSubview(self.textNameLabel)
        self.addSubview(self.courseImageView)
        //        self.addSubview(self.courseLikeLabel)
        //        self.addSubview(self.courseCountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var courseImageView : UIImageView = {
        let libraryImageView = UIImageView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.size.height))
        libraryImageView.image = UIImage(named:"b")
        
        return libraryImageView
    }()
    
    private lazy var textNameLabel : UILabel = {
        let cnl = UILabel()
        cnl.frame = CGRect(x:0, y:0, width:20, height:self.courseImageView.frame.size.height-20)
        cnl.center = self.courseImageView.center
//        cnl.backgroundColor = UIColor.white
        cnl.numberOfLines = 0
        cnl.textAlignment = .center
        cnl.text = "杨老师水墨画课"
        cnl.font = UIFont(name:"Arial", size:16)
        
        return cnl
    }()
    
    //    private lazy var courseNameLabel : UILabel = {
    //        let cnl = UILabel()
    //        cnl.frame = CGRect(x:5, y:self.frame.size.width/2+2, width:self.frame.size.width-10, height:20)
    //        cnl.text = "MARK:滑板教学"
    //        cnl.font = UIFont(name:"Arial", size:14)
    //
    //        return cnl
    //    }()
    //
    //    private lazy var courseLikeLabel : UILabel = {
    //        let cll = UILabel()
    //        cll.frame = CGRect(x:5, y:self.frame.size.width/2+20, width:self.frame.size.width/2-5, height:self.frame.size.height-self.frame.size.width/2-21)
    //        cll.text = "❤︎ 872"
    //        cll.font = UIFont(name:"Arial", size:11)
    //        cll.textColor = UIColor(red:249/255, green:151/255, blue:170/255, alpha:1)
    //        cll.textAlignment = .left
    //
    //        return cll
    //    }()
    //
    //    private lazy var courseCountLabel : UILabel = {
    //        let ccl = UILabel()
    //        ccl.frame = CGRect(x:self.frame.size.width/2-5, y:self.frame.size.width/2+20, width:self.frame.size.width/2-5, height:self.frame.size.height-self.frame.size.width/2-21)
    //        ccl.text = "❉ 8节"
    //        ccl.font = UIFont(name:"Arial", size:11)
    //        ccl.textAlignment = .right
    //        
    //        return ccl
    //    }()
    
}
