//
//  UserFirstCell.h
//  XinMinClub
//
//  Created by Jason_zzzz on 16/3/22.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UITextField *userDataField;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIView *userHeadView;
@property (weak, nonatomic) IBOutlet UILabel *userDetailLabel;
@property (weak, nonatomic) IBOutlet UITextView *userDetailDataField;
@property (weak, nonatomic) IBOutlet UILabel *textNumber;

@end
