//
//  SectionOperation.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/28.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "SectionManageView.h"

@interface SectionOperation : NSObject

// 章节操作
+ (void)sectionManage:(UIView *)backView StatusView:(UIView *)statusview andViewController:(UIViewController *)controller ;
// 收回界面
+ (void)backTap:(UIView *)backView statusView:(UIView *)statusView;
// 弹出界面
- (void)popManageView:(UIViewController <SectionManageDelegate> *)controller backView:(UIView *)backView statusView:(UIView *)statusView tag:(NSInteger)tag data:(SectionData *)data;

@end
