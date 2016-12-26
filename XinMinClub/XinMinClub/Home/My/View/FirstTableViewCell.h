//
//  FirstTableViewCell.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstDelegate <NSObject>

- (void)sign;

@end

@interface FirstTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDetail;
@property (nonatomic, assign) id <FirstDelegate> delegate;

@end
