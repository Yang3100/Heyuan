//
//  courseCollection.swift
//  course
//
//  Created by 杨科军 on 2016/11/22.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit
import Foundation

class courseCollection: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    private var dictDataa:NSDictionary?
    private var lay:UICollectionViewFlowLayout?
    private var frm:CGRect?
    
    init(frame:CGRect, layout:UICollectionViewFlowLayout, dictData:NSDictionary) {
        super.init(frame:frame, collectionViewLayout:layout)
        self.frm = frame
        self.lay = layout
        self.dictDataa = dictData
        self.addSubview(self.courseCollectionView)
        // 添加观察者（通知中心）
        NotificationCenter.default.addObserver(self, selector:#selector(notificationAction(fication:)), name: NSNotification.Name(rawValue:"scrollIsLock"), object:nil);
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func notificationAction(fication : NSNotification){
//        print("44--\(fication.userInfo!["scrollY"] as! Float)")
        if  fication.userInfo!["scrollY"] as! Float > Float(screenHeight/3-64) {
            self.courseCollectionView.isScrollEnabled = true
        }
        else {
            self.courseCollectionView.isScrollEnabled = false
        }
    }
//    deinit {
//        //移除通知中心
//        NotificationCenter.default.removeObserver(self, forKeyPath:"scrollY", context:nil);
//    }
    
    private lazy var courseCollectionView : UICollectionView = {
        let ccv = UICollectionView(frame:self.frm!, collectionViewLayout:self.lay!)
        ccv.backgroundColor = UIColor(red:251/255, green:251/255, blue:251/255, alpha:0.98)
        ccv.dataSource = self
        ccv.delegate = self
        ccv.showsHorizontalScrollIndicator = false
        ccv.showsVerticalScrollIndicator = false
        ccv.isScrollEnabled = false
        //设置每一个cell的宽高
        self.lay!.scrollDirection = .vertical
        self.lay!.itemSize = CGSize(width:(screenWidth-60)/3, height:(screenWidth-60)*1.5/3)
        self.lay!.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15)
        // 注册类
        ccv.register(courseCollectionViewCell.self, forCellWithReuseIdentifier: "courseCollectionViewCell")
        
        return ccv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"courseCollectionViewCell", for:indexPath) as! courseCollectionViewCell
        cell.backgroundColor = UIColor(red:181/255, green:181/255, blue:181/255, alpha:0.3)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touchItem:" + String(indexPath.row))
        let clvc = courseListViewController()
        clvc.view.backgroundColor = UIColor.white
        
        self.AppRootViewController()?.present(clvc, animated: true, completion: {
//            clvc.navigationController?.isToolbarHidden = true;
        })
    }
    
    //MARK:滚动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.origin.y<0 {
            self.courseCollectionView.isScrollEnabled = false
        }
    }
    
    func AppRootViewController() -> UIViewController? {
        var topVC  = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
        
}
