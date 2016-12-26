//
//  AboutApp.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "AboutApp.h"
#import "UIView+Draw.h"

@interface AboutApp () {
    UIView *backView_;
    UITextView *textView_;
}

@end

@implementation AboutApp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于软件";
    [self.view addSubview:[self backView]];
    [self.view addSubview:[self textView]];
}

- (UIView *)backView{
    if (!backView_) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.948 alpha:1.000];
        view.frame = CGRectMake(x,y,w / 4 * 3,h / 4);
        view.center = self.view.center;
        [view roundedRectWithConerRadius:6 BorderWidth:0 borderColor:[UIColor whiteColor]];
        backView_ = view;
        NSLog(@"%f%f",backView_.center.x,backView_.center.y);
    }
    return backView_;
}


- (UITextView *)textView
{
    if (!textView_) {
        textView_ = [UITextView new];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        textView_.frame = CGRectMake(x,y,w / 2,h / 5);
        textView_.center = backView_.center;
        textView_.text = @"我的网站\
                          http://kingwant.com\
                          你可以登录网站了解更多关于我们的信息";
        textView_.font = [UIFont systemFontOfSize:16];
        textView_.textAlignment = NSTextAlignmentCenter;
        textView_.backgroundColor = [UIColor clearColor];
    }
    return textView_;
}


@end
