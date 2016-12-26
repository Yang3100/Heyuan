//
//  HomeTableViewCell.h
//  MyCloundMonkeyNew
//
//  Created by Admin on 16/1/20.
//  Copyright © 2016年 Miko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondCellDelegate <NSObject>

- (void)clickButton: (NSInteger)tag;

@end

@interface SecondHomeTableViewCell : UITableViewCell

@property (nonatomic, assign) UIColor *fontColor;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (nonatomic, assign) id <SecondCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *totalBook;
@property (weak, nonatomic) IBOutlet UIButton *downloadBook;
@property (weak, nonatomic) IBOutlet UIButton *lastPlay;
@property (weak, nonatomic) IBOutlet UIButton *iLike;

@end
