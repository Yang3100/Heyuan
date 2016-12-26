//
//  ForgetViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgetDelegate <NSObject>

@optional

- (void)forgetLogin;
- (void)forgetRegister;

@end

@interface ForgetViewController : UIViewController

@property (nonatomic, copy) NSString *iphoneNum;
@property (nonatomic, assign) id <ForgetDelegate> delegate;

@end
