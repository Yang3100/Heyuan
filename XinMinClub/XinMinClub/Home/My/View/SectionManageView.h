//
//  SecionManageView.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/14.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionData.h"

@protocol SectionManageDelegate <NSObject>

@optional
- (void)downloadSection;
- (void)cacenl;

@end


@interface SectionManageView : UIView

@property (nonatomic, assign) id <SectionManageDelegate> delegate;
@property (nonatomic, strong) SectionData *data;
@property (nonatomic, strong) UIButton *likeButton;

@end
