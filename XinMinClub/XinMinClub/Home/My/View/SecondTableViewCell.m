//
//  HomeTableViewCell.m
//  MyCloundMonkeyNew
//
//  Created by Admin on 16/1/20.
//  Copyright © 2016年 Miko. All rights reserved.
//

#import "SecondTableViewCell.h"

@interface SecondHomeTableViewCell (){
    __weak IBOutlet UILabel *total;
    __weak IBOutlet UILabel *download;
    __weak IBOutlet UILabel *recent;
    __weak IBOutlet UILabel *like;
}

@end

@implementation SecondHomeTableViewCell


- (IBAction)buttonAction:(id)sender {
    UIButton *btn = sender;
    [_delegate clickButton:btn.tag];
}

- (void)setFontColor:(UIColor *)fontColor {
    _totalLabel.textColor = fontColor;
    _downloadLabel.textColor = fontColor;
    _recentLabel.textColor = fontColor;
    _likeLabel.textColor = fontColor;
    
}

@end
