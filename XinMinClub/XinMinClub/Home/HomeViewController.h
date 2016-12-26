//
//  HomeViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"

@interface HomeViewController : WMPageController
// 单例
+ (instancetype)shareObject;
// kvo监听的属性
@property (nonatomic) BOOL p_CompleteState;

@end
