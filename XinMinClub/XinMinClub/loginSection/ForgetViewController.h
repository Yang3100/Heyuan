//
//  ForgetViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol forgetDelegate <NSObject>
@optional

- (void)forgetToRegister:(UIViewController*)viewController;
- (void)forgerToLogin:(UIViewController*)viewController;

@end

@interface ForgetViewController : UIViewController

@property (nonatomic, assign) id <forgetDelegate> delegate;

@property (nonatomic, copy) NSString *iphoneNum;

@end
