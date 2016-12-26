//
//  DetailsTableView.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableView : UIView

@property (nonatomic, strong) NSString *libraryID;
@property(nonatomic, copy) NSArray *detailsTextArray;

// 取消第一响应的属性
@property(nonatomic, copy) UITextField *detailsTextField;

@end
