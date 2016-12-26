//
//  MyBookTableViewCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

// 我的文集Cell
#import "MyBookTableViewCell.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 屏幕高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 屏幕宽度

@interface MyBookTableViewCell () 
@end

@implementation MyBookTableViewCell

@synthesize label = label_;
    
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:[self label]];
    }
    return self;
}

- (UILabel *)label {
    if (!label_) {
        label_ = [[UILabel alloc] init];
        label_.frame = CGRectMake(0, 0, 14, 14);
        label_.center = CGPointMake(SCREEN_WIDTH - 40 + label_.bounds.size.width / 2, self.center.y + 3);
        label_.text = @"3";
        [label_ setFont:[UIFont systemFontOfSize:14]];
//        label_.textColor = [UIColor whiteColor];
    }
    return label_;
}

- (UIView *)footLine {
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, SCREEN_WIDTH, 0.5)];
    footLine.backgroundColor = [UIColor colorWithWhite:0.891 alpha:1.000];
    return footLine;
}

@end
