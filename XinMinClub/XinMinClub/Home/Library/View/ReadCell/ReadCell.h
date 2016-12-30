//
//  ReadCell.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/30.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadCell : UITableViewCell

@property(nonatomic, copy) NSString *readTitle;
@property(nonatomic, copy) NSString *readText;
//@property (nonatomic, strong) NSString *readMp3;
//@property(nonatomic, copy) NSDictionary *infoDic;

@property(nonatomic,assign) BOOL state;  // 展开收起的状态，用于键值监听
@property(nonatomic,assign) NSInteger readNum;   // 点击的对象
@property(nonatomic,strong) NSDictionary *json;  // 数据

@end
