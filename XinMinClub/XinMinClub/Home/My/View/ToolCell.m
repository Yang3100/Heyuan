//
//  ToolCell.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ToolCell.h"

@implementation ToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteAction:(id)sender {
    
    UIButton *btn = sender;
    
    [_delegate manageSection:btn.tag];
}

@end
