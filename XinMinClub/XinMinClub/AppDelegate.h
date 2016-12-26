//
//  AppDelegate.h
//  XinMinClub
//
//  Created by yangkejun on 16/3/18.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ICETutorialController.h"
#import "HelloWord.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICETutorialController *leadViewController;
@property (strong, nonatomic) LoginViewController *loginView;
@property (strong, nonatomic) HelloWord *helloWord;
//@property (nonatomic) BOOL PlayCompleteState;

@end

