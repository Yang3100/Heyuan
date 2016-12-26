//
//  ManageCell.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageDelegate <NSObject>

@optional
- (void)playAll;
- (void)manageAll;

@end

@interface ManageCell : UITableViewCell

@property (nonatomic, assign) id <ManageDelegate> manageDelegate;
@property (nonatomic, assign) BOOL selectState;
@property (weak, nonatomic) IBOutlet UIButton *playImage;
@property (weak, nonatomic) IBOutlet UIButton *playLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageButton;
@property (weak, nonatomic) IBOutlet UIButton *manageLabel;

@end
