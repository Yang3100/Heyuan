//
//  BookCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "BookCell.h"
#import "UIView+Draw.h"

@interface BookCell() {
    UIImageView *editDotView;
}

@end

@implementation BookCell
- (IBAction)bookMenu:(id)sender {
    NSLog(@"%@",self.sectionsName.text);
    UIButton *btn = sender;
    [_delegate sectionManage:btn.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    if (self.editing)//仅仅在编辑状态的时候需要自己处理选中效果
    {
        if (selected){
            //选中时的效果
            [editDotView roundedRectWithConerRadius:11 BorderWidth:0 borderColor:[UIColor whiteColor]];
            editDotView.layer.masksToBounds = NO;
            editDotView.image = [UIImage imageNamed:@"DWDCheck_personal"];
        }
        else {
            //非选中时的效果
            [editDotView roundedRectWithConerRadius:11 BorderWidth:1 borderColor:[UIColor colorWithWhite:0.888 alpha:1.000]];
            editDotView.image = nil;
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    if (editing)//编辑状态
    {
            if (![self viewWithTag:10030])  //编辑多选状态下添加一个自定义的图片来替代原来系统默认的圆圈，注意这个图片在选中与非选中的时候注意切换图片以模拟系统的那种效果
            {
                editDotView = [[UIImageView alloc] init];
                editDotView.tag = 10030;
                editDotView.frame = CGRectMake(12,17,22,22);
                [self addSubview:editDotView];
                editDotView.backgroundColor = [UIColor whiteColor];
            }
    }
    else {
        editDotView = [self viewWithTag:10030];
        //非编辑模式下检查是否有dot图片，有的话删除
        if (editDotView)
        {
            [editDotView removeFromSuperview];
        }
    }
}

@end
