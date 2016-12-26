//
//  SectionOperation.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/28.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionOperation.h"

@interface SectionOperation () {
    
    SectionManageView *smView_;
    DataModel *dataModel_;
    BOOL a;
}

@end

@implementation SectionOperation

- (id)init {
    if (self = [super init]) {
        dataModel_ = [DataModel defaultDataModel];
        a = YES;
    }
    return self;
}

+ (void)sectionManage:(UIView *)backView StatusView:(UIView *)statusview andViewController:(UIViewController *)controller {
    
    backView.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        backView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.354];
        statusview.frame = CGRectMake(0, SCREEN_HEIGHT / 6 * 5 - 5, SCREEN_WIDTH, SCREEN_HEIGHT / 6 + 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            statusview.frame = CGRectMake(0, SCREEN_HEIGHT / 6 * 5, SCREEN_WIDTH, SCREEN_HEIGHT / 6);
        }completion:nil];
    }];
}

+ (void)backTap:(UIView *)backView statusView:(UIView *)statusView {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [UIColor clearColor];
        statusView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        backView.hidden = YES;
    }];
}

- (void)popManageView:(UIViewController <SectionManageDelegate> *)controller backView:(UIView *)backView statusView:(UIView *)statusView tag:(NSInteger)tag data:(SectionData *)data {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (a) {
        a = !a;
        backView.hidden = YES;
        backView.backgroundColor = [UIColor clearColor];
        [window addSubview:backView];
        statusView.backgroundColor = [UIColor whiteColor];
        ((SectionManageView *)statusView).delegate = controller;
        [window addSubview:statusView];
    }
    ((SectionManageView *)statusView).data = data;
    [SectionOperation sectionManage:backView StatusView:statusView andViewController:controller];
}

@end
