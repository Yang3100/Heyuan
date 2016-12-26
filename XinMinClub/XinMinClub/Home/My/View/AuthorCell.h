//
//  AuthorCell.h
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/29.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *headLine;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDetail;

@end
