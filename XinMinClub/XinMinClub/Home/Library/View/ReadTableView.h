//
//  ReadTableView.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadTableView : UITableView

@property (nonatomic, assign) NSInteger kj_x; // 显示的是那个1级目录
@property (nonatomic, copy) NSArray *kj_typeee;
@property (nonatomic, copy) NSArray *readTextArray;

@end
