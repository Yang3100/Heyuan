//
//  HelloWord.h
//  XinMinClub
//
//  Created by 贺军 on 16/4/13.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWord : UIViewController

@property(nonatomic,strong) UIImage *advertisementImage;

@property(nonatomic) BOOL ThereAreNoPassword;

// 保存账号密码到本地
-(void)setAccount:(NSString *)account Password:(NSString*)password;
// 获取本地的账号密码
-(void)getAccount;
// 删除本地的账号密码
+(BOOL)deleteAccount;

@end
