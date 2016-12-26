//
//  ManageCell.m
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ManageCell.h"

@interface ManageCell () {
    
}

@end

@implementation ManageCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 去掉点击动画
        self.playLabel.adjustsImageWhenHighlighted = NO;
        self.playImage.adjustsImageWhenHighlighted = NO;
        _selectState = NO;
    }
    return self;
}


- (IBAction)playAll:(id)sender {

    /**********************************
     播放、暂停状态切换
//    _selectState = !_selectState;
//    if (_selectState) {
//        [self.playImage setImage:[UIImage imageNamed:@"Suspend_personal"] forState:UIControlStateNormal];
//        [self.playLabel setTitle:@"暂停播放" forState:UIControlStateNormal];
//    } else {
//        [self.playImage setImage:[UIImage imageNamed:@"Play_personal"] forState:UIControlStateNormal];
//        [self.playLabel setTitle:@"播放全部" forState:UIControlStateNormal];
//    }
     **********************************/
    [_manageDelegate playAll];
}
- (IBAction)manageAll:(id)sender {
    [_manageDelegate manageAll];
}

@end
