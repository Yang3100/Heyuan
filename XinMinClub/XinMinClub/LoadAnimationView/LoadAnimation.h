//
//  LoadAnimation.h
//  XinMinClub
//
//  Created by 杨科军 on 2017/1/5.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadAnimation : UIView

+ (instancetype)defaultDataModel;

- (void)startLoadAnimation;

- (void)endLoadAnimation;



//清除图片缓存
- (void)clearTmpPics;

@end
