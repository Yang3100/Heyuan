//
//  RegisterViewController.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterDelegate <NSObject>

@optional

- (void)registerLogin;

@end

@interface RegisterViewController : UIViewController

@property (nonatomic, assign) id <RegisterDelegate> delegate;

@end
