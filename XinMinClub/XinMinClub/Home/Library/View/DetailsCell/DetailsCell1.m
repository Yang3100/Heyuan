//
//  DetailsCell1.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/29.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsCell1.h"

@interface DetailsCell1()

@property (weak, nonatomic) IBOutlet UILabel *details1TextLabel1;
@property (weak, nonatomic) IBOutlet UILabel *details1TextLabel2;

@end

@implementation DetailsCell1

- (void)setDetails1Text:(NSString *)details1Text{
    NSString *s = [NSString stringWithFormat:@"%@ :",details1Text];
    self.details1TextLabel1.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    self.details1TextLabel1.text = s;
}

- (void)setDetails1Title:(NSString *)details1Title{
    self.details1TextLabel2.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    self.details1TextLabel2.text = details1Title;
}

@end
