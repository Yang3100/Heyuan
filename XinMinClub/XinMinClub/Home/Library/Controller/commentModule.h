//
//  commentModule.h
//  XinMinClub
//
//  Created by 杨科军 on 2017/3/1.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentModule : UIView

- (instancetype)initIsHidden:(BOOL)hidde;

@property(nonatomic,assign) BOOL isHiddenView;  // 是否隐藏

@property(nonatomic,copy) NSString *bookID; // 书集ID
@property(nonatomic,copy) UIView *kj_backView;

@end
