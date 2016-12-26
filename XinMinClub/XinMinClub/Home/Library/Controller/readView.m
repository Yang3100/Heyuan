//
//  readView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "readView.h"

@implementation readView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setIsTopView:(BOOL)isTopView{
    NSLog(@"readTop:%d",isTopView);
    
    [self startNetwork];
}

- (void)startNetwork{

}

@end
